pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import 'zeppelin-solidity/contracts/token/ERC20/ERC20.sol';

contract Airdropper is Ownable {
    using SafeMath for uint256;
    uint256 public airdropTokens;
    uint256 public decimalFactor;
    uint256 public totalClaimed;
    uint256 public amountOfTokens;
    mapping (address => bool) public tokensReceived;
    ERC20 public token;

    function Airdropper(uint256 _amount) public {
        decimalFactor = 10**18;
        totalClaimed = 0;
        amountOfTokens = _amount;
    }

    function airdrop(address[] _recipients) public onlyOwner {        
        for (uint256 i = 0; i < _recipients.length; i++) {
            if (!tokensReceived[_recipients[i]]) {
                require(token.transfer(_recipients[i], amountOfTokens * decimalFactor));
                tokensReceived[_recipients[i]] = true;
            }
        }
        totalClaimed = totalClaimed.add(amountOfTokens * decimalFactor * _recipients.length);
    }

    function airdropDynamic(address[] _recipients, uint256[] _amount) public onlyOwner {
        for (uint256 i = 0; i < _recipients.length; i++) {
            if (!tokensReceived[_recipients[i]]) {    
                require(token.transfer(_recipients[i], _amount[i] * decimalFactor));
                tokensReceived[_recipients[i]] = true; 
                totalClaimed = totalClaimed.add(_amount[i] * decimalFactor);
            }
        }
    }

    function reset() public onlyOwner {
        require(token.transfer(owner, remainingTokens()));
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        token = ERC20(_tokenAddress);
    }

    function setTokenNumber(uint256 _amount) public onlyOwner {
        amountOfTokens = _amount;
    }

    function remainingTokens() public view returns (uint256) {
        return token.balanceOf(this);
    }
}
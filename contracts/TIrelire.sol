// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract Tirelire{

    error NotEnoughMoneyInBalance();
    error NoDepositMade();
    error NotEnoughMoneyForPenalty();
    error PaymentFailed();

    mapping (address => uint) public balances;
    mapping (address => uint) public lastDepositTime;


    function pay() public payable{
        balances[msg.sender] += msg.value;
        lastDepositTime[msg.sender] = block.timestamp;
    }

    function withdraw(uint amount) public{
        uint final_amount = amount;
        if(lastDepositTime[msg.sender] == 0){
            revert NoDepositMade();
        }

        //24 hours = 86400 seconds
        if(block.timestamp - lastDepositTime[msg.sender] < 86400){
            final_amount = amount * 6 / 5;
        }

        //In case the sender doesn't have the money
        if(amount > balances[msg.sender]){
            revert NotEnoughMoneyInBalance();
        }

        //In case the sender doesn't have the money including 20% penalty
        if(final_amount > balances[msg.sender]){
            revert NotEnoughMoneyForPenalty();
        }
        
        (bool sent, ) = msg.sender.call{value: amount}("");
        if(sent){
            balances[msg.sender] -= final_amount;
        }
    }
}
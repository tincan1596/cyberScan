// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract EtherGame {
    uint256 public constant stake = 0.5 ether;
    uint256 public constant MaxEther = 10 ether;
    uint256 private currentBalance = 0;
    bool private locked;

    receive() external payable {
        deposit();
    }

    modifier noReentrancy() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    function deposit() public payable noReentrancy {
        require(msg.value == stake, "0.5 ether only");
        if (currentBalance < MaxEther) {
            currentBalance += msg.value;
        } else {
            uint256 balance = currentBalance;
            require(currentBalance >= MaxEther, "Not enough ether to reward");
            (bool success,) = msg.sender.call{value: balance}("");
            require(success, "Transfer failed");
        }
    }
}

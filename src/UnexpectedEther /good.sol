// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract EtherGame {
    uint256 public constant MinEther = 0.5 ether;
    uint256 public constant MaxEther = 10 ether;
    uint256 private currentBalance = 0;

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value >= MinEther, "0.5 ether only");
        if (currentBalance < MaxEther) {
            currentBalance += msg.value;
        } else {
            currentBalance = 0;
            (bool success,) = msg.sender.call{value: 10}("");
            require(success, "failed");
        }
    }

    function withdraw() external {
        require(currentBalance > 0, "No ether to withdraw");
        uint256 amount = currentBalance;
        currentBalance = 0;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "failed");
    }
}

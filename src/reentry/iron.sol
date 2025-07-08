// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract vault {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public timestamps;
    uint256 public timelimit = 1 weeks;
    uint256 public maxwithdraw = 1 ether;

    receive() external payable {
        deposit(); // keeping the code clean, avoid putting login in recieve()
    }

    function deposit() public payable {
        require(msg.value > 0, "deposite must be greater tha n0");
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "insufficient balance");
        require(block.timestamp >= timestamps[msg.sender] + timelimit, "minimum cooldown period in 1 week");
        require(amount <= maxwithdraw, "withdrawal amount exceeds limit");

        // interacting the the EOA or other contract account before updating the state lead to Re-Entrancy attack
        (bool success, )= msg.sender.call{value: amount}("");
        require(success, "withdraw failed");

        // state change after interaction
        balances[msg.sender] -= amount;
        timestamps[msg.sender] = block.timestamp;
    }
    
    function getbalance( address user) external view returns (uint256) {
        return balances[user];
    }
}
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

// A simple timelock contract that allows users to deposit and withdraw funds after a certain period
contract timelock {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public timestamps;
    uint256 public timelimit = 1 weeks;

    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
        timestamps[msg.sender] = block.timestamp;
    }

    // Withdraw function that checks the timelock condition
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(block.timestamp >= timestamps[msg.sender] + timelimit, "Withdrawal is locked");

        balances[msg.sender] -= amount;
        timestamps[msg.sender] = block.timestamp;

        payable(msg.sender).transfer(amount);
    }

    function getbalance(address user) external view returns (uint256) {
        return balances[user];
    }

    // this part ads the overflow vulnerability
    function increaseTimelimit(uint256 additionalTime) external {
        require(additionalTime > 0, "Additional time must be greater than 0");
        timestamps[msg.sender] += additionalTime; // This can cause an overflow if timelimit is too large
    }
}

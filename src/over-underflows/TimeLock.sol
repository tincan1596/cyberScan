// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

//the arithemetic vulnerability was resolved from after the solidity ^0.8.0 version so this contract is just for educational purposes

// A simple timelock contract that allows users to deposit and withdraw funds after a certain period
contract TimeLock {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public timestamps;
    uint256 public TimeLimit = 1 weeks;

    error ZeroAmountNotAllowed();

    function deposit() external payable {
        if (msg.value == 0) revert ZeroAmountNotAllowed();
        balances[msg.sender] += msg.value;
        timestamps[msg.sender] = block.timestamp + TimeLimit;
    }

    // Withdraw function that checks the timelock condition
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(block.timestamp >= timestamps[msg.sender], "Withdrawal is locked");

        balances[msg.sender] -= amount;
        timestamps[msg.sender] = block.timestamp + TimeLimit;

        payable(msg.sender).transfer(amount);
    }

    function getbalance(address user) external view returns (uint256) {
        return balances[user];
    }

    // this part ads the overflow vulnerability
    function increaseTimeLimit(uint256 additionalTime) external {
        require(additionalTime > 0, "Additional time must be greater than 0");
        timestamps[msg.sender] += additionalTime; // This can cause an overflow if TimeLimit is too large
    }
}

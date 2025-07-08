// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract VaultSafe {
    uint256 public constant WEEK = 7 days;
    uint256 public constant MAX_WITHDRAW = 1 ether;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastWithdrawTime;

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value > 0, "Must deposit something");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        require(amount <= MAX_WITHDRAW, "Exceeds weekly limit");
        require(block.timestamp >= lastWithdrawTime[msg.sender] + WEEK, "Withdraw too soon");

        // Update state before external call
        balances[msg.sender] -= amount;
        lastWithdrawTime[msg.sender] = block.timestamp;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}

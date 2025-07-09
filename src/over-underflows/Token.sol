// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

// this contract shows and underflow vulnerability, though it is not exploitable in solidity ^0.8.0 and above
// A simple token contract that allows users to transfer tokens and check balances

contract Token {
    mapping(address => uint256) public balances;

    error ZeroAmountNotAllowed();

    function transfer(address to, uint256 amount) external {
        if (amount == 0) revert ZeroAmountNotAllowed();
        require(balances[msg.sender] - amount >= 0, "Insufficient balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        balances[msg.sender] += amount;
    }

    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }
}

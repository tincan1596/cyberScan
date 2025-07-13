// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IFibLib {
    function fib(uint256 start, uint256 n) external pure returns (uint256);
}

contract game {
    address public immutable fiblib;
    uint256 public count;

    event Withdraw(address indexed player, uint256 n, uint256 amount);

    constructor(address _fiblib) {
        fiblib = _fiblib;
    }

    receive() external payable {}

    function withdraw() external {
        uint256 n = count;
        bytes memory data = abi.encodeWithSignature("fib(uint256,uint256)", 3, n);
        (bool ok, bytes memory result) = fiblib.delegatecall(data);
        require(ok, "Delegatecall to FibLib failed");
        uint256 amount = abi.decode(result, (uint256));
        count++;
        require(address(this).balance >= amount, "Insufficient balance");
        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Ether transfer failed");
        emit Withdraw(msg.sender, n, amount);
    }
}

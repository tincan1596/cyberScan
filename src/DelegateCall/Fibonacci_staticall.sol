// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract FibonacciGameWithLibraryCall {
    address public immutable fibLib; // Address of deployed FibLib
    uint256 public withdrawCount;

    event Withdrawal(address indexed player, uint256 nth, uint256 amount);

    constructor(address _fibLib) {
        fibLib = _fibLib;
    }

    receive() external payable {}

    function withdraw() external {
        uint256 nth = withdrawCount;

        // Encode staticcall to the external library
        bytes memory data = abi.encodeWithSignature("fib(uint256,uint256)", 3, nth);
        (bool ok, bytes memory result) = fibLib.staticcall(data);
        require(ok, "Staticcall to FibLib failed");

        uint256 amount = abi.decode(result, (uint256));
        withdrawCount++;

        require(address(this).balance >= amount, "Insufficient balance");
        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Ether transfer failed");

        emit Withdrawal(msg.sender, nth, amount);
    }
}

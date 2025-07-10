// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;
// forcing ether to a contract
// standard practice - invarient checking - dotn't rely on "address(this).balance".
// self-destruc and prefund to the address are 2 possible ways to change contract balance without using payable function.
// this contract allow 0.5 ether to be sent to it and reward 10 ether to the last player, any player can claim the existing ether balance before reaching 10 ether.

contract EtherGame {
    uint256 public constant MinEther = 0.5 ether;
    uint256 public constant MaxEther = 10 ether;
    uint256 private currentBalance = address(this).balance; // vulneralble to prefund
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

    function deposit() public payable {
        require(msg.value >= MinEther, "0.5 ether only");
        if (currentBalance < MaxEther) {
            currentBalance += msg.value;
        } else {
            reward();
        }
    }

    function reward() public noReentrancy {
        require(currentBalance >= MaxEther, "Not enough ether to reward");
        (bool success,) = msg.sender.call{value: address(this).balance}(""); // vulnerable to forced fund from self-destruct
        require(success, "Transfer failed");
    }
}

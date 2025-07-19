// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract wallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        // Function to receive Ether. msg.data must be empty
    }

    function withdraw(address recipient) public {
        require(tx.origin == owner, "Only the owner can withdraw"); // this line is vulnerable since the attacker can make the owner
        // call this function and then call the fallback function to withdraw funds
        (bool sent,) = recipient.call{value: address(this).balance}("");
        require(sent, "Ether transfer failed");
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract tokens {
    address public owner;
    uint256 public constant price = 5;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public tokenCount;
    address[] public Investors;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function deposite() public payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        if (balances[msg.sender] == 0) {
            Investors.push(msg.sender);
        }
        balances[msg.sender] += msg.value;
    }

    // the owner distributes tokens to the users
    function distribute() public onlyOwner {
        require(Investors.length > 0, "No users to distribute tokens to");

        // This for loop can be inflated by third party and make the contract called by owner run out of gas,
        // therefore loking the ETH

        for (uint256 i = 0; i < Investors.length; i++) {
            address user = Investors[i];
            uint256 ethAmaount = balances[user];
            if (ethAmaount == 0) continue;

            uint256 token = ethAmaount * price;
            tokenCount[user] += token;

            balances[user] = 0;
        }
    }

    // block for sending the tokens to investors
}

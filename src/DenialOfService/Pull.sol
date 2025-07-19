// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract tokens {
    address public owner;
    uint256 public constant price = 5;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public tokenCount;
    address[] public Investors;

    event Withdraw(address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function deposite() public payable {
        require(msg.value >= 1 ether, "Deposit must be greater than 1 ether");
        require(msg.value % 1 ether == 0, "Deposit must be in whole ether amounts");
        if (balances[msg.sender] == 0) {
            Investors.push(msg.sender);
        }
        balances[msg.sender] += msg.value;
        tokenCount[msg.sender] += (msg.value / 1 ether) * price;
    }

    function withdraw() public {
        uint256 amount = tokenCount[msg.sender];
        require(amount > 0, "No tokens to withdraw");
        tokenCount[msg.sender] = 0;
        balances[msg.sender] = 0;
        emit Withdraw(msg.sender, amount);
        (bool sent,) = msg.sender.call{value: amount / price}("");
        require(sent, "Ether transfer failed");

        // block for sending the tokens to investors

        removeInvestor(msg.sender);
    }

    function removeInvestor(address user) internal {
        for (uint256 i = 0; i < Investors.length; i++) {
            if (Investors[i] == user) {
                Investors[i] = Investors[Investors.length - 1];
                Investors.pop();
                break;
            }
        }
    }
}

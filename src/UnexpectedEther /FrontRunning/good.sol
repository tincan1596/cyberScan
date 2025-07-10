// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract EtherGame {
    uint256 public constant stake = 0.5 ether;
    uint256 public constant MaxEther = 10 ether;
    uint256 private currentBalance = 0;
    bool private locked;
    mapping(address => uint256) public playerBalances;

    receive() external payable {
        deposit();
    }

    modifier noReentrancy() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    function deposit() public payable noReentrancy {
        require(msg.value == stake, "0.5 ether only");
        currentBalance += msg.value;
        playerBalances[msg.sender] += msg.value;
        if (currentBalance < MaxEther) {} else {
            require(currentBalance == MaxEther, "reward != 10 ether");
            require(address(this).balance >= currentBalance, "Insufficient contract balance");
            currentBalance = 0;
            (bool success,) = msg.sender.call{value: MaxEther}("");
            require(success, "Transfer failed");
        }
    }

    function withdraw() external noReentrancy {
        uint256 playerBalance = playerBalances[msg.sender];
        require(playerBalance > 0, "No ether to withdraw");
        playerBalances[msg.sender] = 0;
        (bool success,) = msg.sender.call{value: playerBalance}("");
        require(success, "Transfer failed");
    }

    function getCurrentBalance() external view returns (uint256) {
        return playerBalances[msg.sender];
    }
}

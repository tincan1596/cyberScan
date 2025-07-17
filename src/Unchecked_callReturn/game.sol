// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract dice {
    bool public payout;
    uint256 public price;
    address public winner;

    // .. some game logic here

    function award() internal {
        require(!payout, "Payout not available");
        payable(winner).send(price); // This line is vulnerable to unchecked call return
        // The send function returns false if the transfer fails, but this is not checked
        // This can lead to a situation where the payout is not actually sent, but the state
        // is updated to reflect that a payout has occurred, leading to potential loss of funds.
        // In Solidity ^0.8.0 and above, this would revert the transaction instead
        // of allowing the state to change without a successful transfer.
        // In this case, the payout is set to true regardless of whether the transfer was successful
        payout = true;
    }

    function withdraw() external {
        require(payout, "Payout not available");
        (bool ok,) = msg.sender.call{value: address(this).balance}("");
        require(ok, "Transfer failed");
    }
}

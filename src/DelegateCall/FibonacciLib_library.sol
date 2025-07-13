// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

library FibLib {
    function fib(uint256 start, uint256 n) external pure returns (uint256) {
        if (n == 0) return start;
        if (n == 1) return start + 1;

        uint256 a = start;
        uint256 b = start + 1;

        unchecked {
            for (uint256 i = 2; i <= n; ++i) {
                uint256 temp = a + b;
                a = b;
                b = temp;
            }
        }

        return b;
    }
}

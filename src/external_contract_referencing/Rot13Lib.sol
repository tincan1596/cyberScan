// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

library Rot13Lib {
    function encrypt(bytes memory data) internal pure returns (bytes memory) {
        for (uint256 i; i < data.length;) {
            uint8 c = uint8(data[i]);
            if (c >= 65 && c <= 90) data[i] = bytes1(uint8((c - 65 + 13) % 26 + 65));
            else if (c >= 97 && c <= 122) data[i] = bytes1(uint8((c - 97 + 13) % 26 + 97));
            unchecked {
                ++i;
            }
        }
        return data;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Encryptor {
    address public rot13Lib; // Mutable external library

    constructor(address _lib) {
        rot13Lib = _lib;
    }

    // Allows updating the library address, but leaves vulnerable to address changes
    function updateLibrary(address _newLib) external {
        // ⚠️ WARNING: No access control!
        rot13Lib = _newLib;
    }

    function encrypt(bytes memory data) external returns (bytes memory result) {
        // Call encrypt(data) using delegatecall
        (bool ok, bytes memory returned) = rot13Lib.delegatecall(abi.encodeWithSignature("encrypt(bytes)", data));
        require(ok, "delegatecall failed");
        result = abi.decode(returned, (bytes));
    }
}

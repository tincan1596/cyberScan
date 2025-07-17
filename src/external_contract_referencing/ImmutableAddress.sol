// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Encrypt {
    address immutable defaultLib;
    address public newLib;
    address public owner;

    constructor(address _defaultLib) {
        defaultLib = _defaultLib;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function updateLibrary(address _newLib) external onlyOwner {
        require(_newLib.code.length > 0, "Not a contract");
        newLib = _newLib;
    }

    function encrypt(bytes memory data) external returns (bytes memory result) {
        address lib = newLib == address(0) ? defaultLib : newLib;
        (bool ok, bytes memory returned) = lib.call(abi.encodeWithSignature("encrypt(bytes)", data));
        require(ok);
        result = abi.decode(returned, (bytes));
    }
}

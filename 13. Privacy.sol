//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//web3.eth.getStorageAt("0x7D185ef96fC0AbD17C9AEDbB85245EeC96C577e9",5)
contract Attack{
  function turn(bytes32 _In) public pure returns (bytes16 _out){
    _out = bytes16(_In);
    return _out;
  }
}
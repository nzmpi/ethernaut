//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function raiseAlert(address user) external;
}

/**
 * @dev The problem is that if we try to call `sweepToken` with LegacyToken address,
 * it will use `transfer`, which overrides the standard ERC20 transfer function.
 * That function will call DET in which `origSender` == msg.sender in LegacyToken,
 * which is CryptoVault address. We need to prevent that.
 */
contract DetectionBot {
    address immutable vault;

    constructor(address _vault) payable {
        vault = _vault;
    }
    
    function handleTransaction(address user, bytes calldata msgData) external {
        address origSender;
        // the first 4 bytes are the function selector
        (,, origSender) = abi.decode(msgData[4:], (address, uint256, address));
        
        if (origSender == vault) {
            IForta(msg.sender).raiseAlert(user);
        }
    }
}



















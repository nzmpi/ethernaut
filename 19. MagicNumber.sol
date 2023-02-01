//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    event Log(address _addr);

    function deploy() external {
        bytes memory bytecode = hex"69602a60005260206000f3600052600a6016f3";
        address _addr;
        assembly {
          _addr := create(0, add(bytecode, 0x20), 0x13) // add(...,0x20) -> 0x20 == 32 bytes that stores array's length, which we don't need; 0x13 == 19 bytes == size of bytecode 
        }
        require(_addr != address(0));
        emit Log(_addr);
    }
}

/*

602a 6000 52 6020 6000 f3
69 602a60005260206000f3 6000 52 600a 6016 f3 
69602a60005260206000f3600052600a6016f3

1. code that returns uint(42) == 602a60005260206000f3

  602a 6000 52 6020 6000 f3:
    1. 602a -> PUSH1 2a -> PUSH1 == 60, (42)_10 == (2a)_16 | we need to push 1 byte value into stack for mstore(p, v), 
                                                           | where p is starting point in memory and v is what we store. Pushing in reverse order
    2. 6000 -> PUSH1 00 -> 00 is 0x00 empty memory start 
    3. 52 -> MSTORE | stores data
    4. 6020 -> (20)_16 == (32)_10 -> 32 bytes | we need to return all 32 bytes (and not 1 byte), because it safes 1 byte in 32 bytes slot (wtih first 31 bytes of zeros)
    5. 6000 -> same as 2
    6. f3 -> RETURN | return(p,s), where s is the length of returning data (32 bytes) and p is the starting point in memory 

2. code that creates contract which returns uint(42) == 69602a60005260206000f3600052600a6016f3

  69 602a60005260206000f3 6000 52 600a 6016 f3:
    1. 69 -> PUSH10 | pushes 10 bytes, which is the length of the returning code above
    2. 602a60005260206000f3 | the returning code, which is 10 bytes
    3. 6000 52 | we store the returning code at 0x00
    4. 600a -> (0a)_16 == (10)_10 -> 10 bytes
    5. 6016 -> (16)_16 == (22)_10 -> 32 - 10 bytes | we only used 10 bytes for the returning code, first 22 bytes are zeros
    6. f3

opcodes: https://ethervm.io/
solidity to opcode: https://www.evm.codes/playground?fork=merge 

*/











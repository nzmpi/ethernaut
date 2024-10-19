//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    constructor() payable {
        assembly {
            mstore(0, 0x602a60005260206000f300000000000000000000000000000000000000000000)
            return(0, 10)
        }
    }
}

/*

602a 6000 52 6020 6000 f3

1. 602a -> PUSH1 2a -> PUSH1 == 60, (42)_10 == (2a)_16 | we need to push 1 byte value into stack for mstore(p, v), where p is starting point in memory and v is what we store. Pushing in reverse order
2. 6000 -> PUSH1 00 -> 00 is 0x00 empty memory start 
3. 52 -> MSTORE | stores data in memory
4. 6020 -> (20)_16 == (32)_10 -> 32 bytes | we need to return all 32 bytes (and not 1 byte), because it safes 1 byte in 32 bytes slot (with first 31 bytes of zeros)
5. 6000 -> same as 2
6. f3 -> RETURN | return(p,s), where s is the length of returning data (32 bytes) and p is the starting point in memory

opcodes: https://ethervm.io/
solidity to opcode: https://www.evm.codes/playground?fork=merge 

*/











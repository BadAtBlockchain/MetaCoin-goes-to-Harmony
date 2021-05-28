# MetaCoin-goes-to-Harmony  
  
Part of my #100daysofcode venture, focusing on Solidity and the Harmony protocol. Check out the write ups on https://badatblockchain.github.io    
  
Planning to grow the default MetaCoin project into an experimental smart contract including a range of mechanics. Purely fun and free knowledge. Probably won't be production ready but I'll work on it.  
  
### Usage:  
  
Aslong as you have git, node and truffle installed, the following should work:  
  
```
git clone https://github.com/BadAtBlockchain/MetaCoin-goes-to-Harmony.git
cd MetaCoin-goes-to-Harmony
npm install

truffle compile -all
truffle migrate --network testnet
truffle test -- network testnet
```
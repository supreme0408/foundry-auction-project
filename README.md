# About Project
This project contains 
- two smart contracts
    - ChangingingNFT.sol
    - Auction.sol
- deploying scripts
    - DeployChangingNFT.s.sol
    - DeployNFTAuction.s.sol
- testing contract
    - ChangingNFTTest.t.sol
    - NFTAuctionTest.t.sol
## Foundry Commands
```
forge init
forge compile
forge test
```
### Deploying contracts
```
forge script script/DeployChangingNFT.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY1
forge script script/DeployNFTAuction.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```
### Calling Contract functions
```
cast send _nft contract address_ "mintNFT()" --rpc-url $RPC_URL --private-key $PRIVATE_KEY1
cast send _auction contract address_ "createAuction(address,uint256,uint256,uint256)" _nft contract address_ _token ID_ _start price_ _auction duration_ --private-key $PRIVATE_KEY1 --rpc-url $RPC_URL
cast send _auction contract address_ "placeBid(uint256,uint256)" _auction ID_ _bid amount_ --private-key $PRIVATE_KEY2 --rpc-url $RPC_URL
cast send _auction contract address_ "endAuction(uint256)" _auction ID_ --private-key $PRIVATE_KEY1 --rpc-url $RPC_URL
```


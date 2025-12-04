BUSD_CONTRACT_ADDRESS := 0x936a9BCE52BF0841b372aa9A7ba8F243b915271A
CCNFT_CONTRACT_ADDRESS := 0xd3482a9b5A5aB89174EA6475E06C68D772885bd7

C1_ADDRESS := 0xf765ad78a700d61be2a4146d95cd4709d2bbe722
C1_PRIVATE_KEY := 0x7ea1bd15270724969703d599e8e71f4a483362419125178a2bdfe8f7248aa462
C2_ADDRESS := 0xc0d5f054c3970838a15b23dd22bf629e8c329b06
C2_PRIVATE_KEY := 6e2b063790f247d6e65f92d7943c0c3bc9424b31bdbe6b61c2cc54b8d722e3d3
FUNDS_ADDRESS := 0x2599e05710143a2f51eb31a938a37500b18405ef
FUNDS_PRIVATE_KEY := bac9d25921dfbfc5f0344026c6f559782c5386c6848218b52932eb3acccd2e48
FEES_ADDRESS := 0xa42f0365f78371c4c80e5cb6adf25abe4c58d8c5

PRIVATE_KEY := 5e7b0fce2afd4835a22b6711d6f42e6774486a29d4a285e8a0c3ec3207de9e9f
RPC_URL := https://eth-sepolia.g.alchemy.com/v2/XivGz4OIXrJNo7lX_50Gj
ETHERSCAN_API_KEY := 1P3UYRYWJT9K95I89R6BBD9PP3HVUE3GYC

NETWORK_ARGS := --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
NETWORK_ARGS_C1 := --rpc-url $(RPC_URL) --private-key $(C1_PRIVATE_KEY) --broadcast
NETWORK_ARGS_C2 := --rpc-url $(RPC_URL) --private-key $(C2_PRIVATE_KEY) --broadcast
NETWORK_ARGS_FUNDS := --rpc-url $(RPC_URL) --private-key $(FUNDS_PRIVATE_KEY) --broadcast

NETWORK_ARGS_CAST := --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY)
NETWORK_ARGS_CAST_C1 := --rpc-url $(RPC_URL) --private-key $(C1_PRIVATE_KEY)
NETWORK_ARGS_CAST_C2 := --rpc-url $(RPC_URL) --private-key $(C2_PRIVATE_KEY)
NETWORK_ARGS_CAST_FUNDS := --rpc-url $(RPC_URL) --private-key $(FUNDS_PRIVATE_KEY)

NETWORK_ARGS_VERIFY := --rpc-url $(RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify -vvv --etherscan-api-key $(ETHERSCAN_API_KEY)

deployAndVerifyBUSD:
	@forge script script/DeployBUSD.s.sol:DeployBUSD $(NETWORK_ARGS_VERIFY)

deployAndVerifyCCNFT:
	@forge script script/DeployCCNFT.s.sol:DeployCCNFT $(NETWORK_ARGS_VERIFY)

transferBUSDToAccount:
	@cast send $(BUSD_CONTRACT_ADDRESS) "transfer(address,uint256)" $(C1_ADDRESS) 1000000000000000000000000 $(NETWORK_ARGS_CAST)

transferBUSDToAccountInteractions:
	@forge script script/interactions.s.sol:TransferBUSD $(NETWORK_ARGS)

approveBUSDForCCNFT:
	@cast send $(BUSD_CONTRACT_ADDRESS) "approve(address,uint256)" $(CCNFT_CONTRACT_ADDRESS) 1000000000000000000000000 --private-key $(C1_PRIVATE_KEY) --rpc-url $(RPC_URL)

approveBUSDForCCNFTFunds:
	@cast send $(BUSD_CONTRACT_ADDRESS) "approve(address,uint256)" $(CCNFT_CONTRACT_ADDRESS) 1000000000000000000000000 $(NETWORK_ARGS_CAST_FUNDS)

setCanBuyForCCNFT:
	@cast send $(CCNFT_CONTRACT_ADDRESS) "setCanBuy(bool)" true $(NETWORK_ARGS_CAST)

setValidValueTokensForCCNFT:
	@cast send $(CCNFT_CONTRACT_ADDRESS) "addValidValues(uint256)" 100000000000000000000 $(NETWORK_ARGS_CAST)

buyCCNFTTokensC1:
	@cast send $(CCNFT_CONTRACT_ADDRESS) "buy(uint256,uint16)" 100000000000000000000 2 $(NETWORK_ARGS_CAST_C1)

buyCCNFTTokensC2:
	@cast send $(CCNFT_CONTRACT_ADDRESS) "buy(uint256,uint16)" 100000000000000000000 5 $(NETWORK_ARGS_CAST_C2)

buyCCNFTTokensC2Fail:
	@cast send $(CCNFT_CONTRACT_ADDRESS) "buy(uint256,uint16)" 100000000000000000000 12 $(NETWORK_ARGS_CAST_C2)

setAccountsForCCNFTInteractions:
	@forge script script/interactions.s.sol:setAccountsForCCNFT $(NETWORK_ARGS)

setFundsTokensForCCNFT:
	@cast send $(CCNFT_CONTRACT_ADDRESS) "setFundsToken(address)" $(BUSD_CONTRACT_ADDRESS) $(NETWORK_ARGS_CAST)

setSetsForCCNFTInteractions:
	@forge script script/interactions.s.sol:setSetsForCCNFT $(NETWORK_ARGS)

setTraderForCCNFTC1:
	@cast send $(CCNFT_CONTRACT_ADDRESS) "putOnSale(uint256, uint256)" 9 120000000000000000000 $(NETWORK_ARGS_CAST_C2)
	@cast send $(CCNFT_CONTRACT_ADDRESS) "trade(uint256)" 9 $(NETWORK_ARGS_CAST_C1)

CCNFTClaimTokenInteractions:
	@forge script script/interactions.s.sol:CCNFTClaimToken $(NETWORK_ARGS_C1)

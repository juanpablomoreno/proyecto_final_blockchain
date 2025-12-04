//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BUSD} from "../src/BUSD.sol";
import {CCNFT} from "../src/CCNFT.sol";

contract TransferBUSD is Script {

    function run() external {
        address busdAddress = 0x936a9BCE52BF0841b372aa9A7ba8F243b915271A;
        address to_account = 0xc0d5F054C3970838a15B23DD22bF629e8C329B06; // Dirección de c2
        uint256 amount = 1000000000000000000000000; // 1,000,000 BUSD with 18 decimals

        TransferBUSDToAccountOnContract(busdAddress, to_account, amount);
    }

    function TransferBUSDToAccountOnContract(address busdAddress, address to_account, uint256 amount) public {
        vm.startBroadcast();

        // Realizar la transferencia de BUSD
        if(!BUSD(busdAddress).transfer(to_account, amount)) {
            revert("Transfer failed");
        }

        // Finalizar la transmisión
        vm.stopBroadcast();
    }
}

contract setAccountsForCCNFT is Script {

    function run() external {
        address ccnftAddress = 0xd3482a9b5A5aB89174EA6475E06C68D772885bd7;
        address fundsAddress = 0x2599E05710143A2F51eB31A938A37500b18405Ef;
        address feesAddress = 0xa42f0365f78371C4C80e5CB6ADf25ABE4c58D8c5;

        setAccountsForCCNFTContract(ccnftAddress, fundsAddress, feesAddress);
    }

    function setAccountsForCCNFTContract(address ccnftAddress, address funds, address feeds) public {
        vm.startBroadcast();

        // Establecer la cuenta de fees
        CCNFT(ccnftAddress).setFeesCollector(feeds);
        // Establecer la cuenta de funds
        CCNFT(ccnftAddress).setFundsCollector(funds);

        // Finalizar la transmisión
        vm.stopBroadcast();
    }
}

contract CCNFTBuyTokens is Script {

    function run() external {
        address ccnftAddress = 0xd3482a9b5A5aB89174EA6475E06C68D772885bd7;
        uint256 value = 100000000000000000000; // precio de cada token
        uint16 amount = 3; // cantidad de tokens a comprar

        buyCCNFTTokens(ccnftAddress, value, amount);
    }

    function buyCCNFTTokens(address ccnftAddress, uint256 value, uint16 amount) public {
        vm.startBroadcast();

        // Comprar tokens CCNFT
        CCNFT(ccnftAddress).buy(value, amount);

        // Finalizar la transmisión
        vm.stopBroadcast();
    }
}   

contract setSetsForCCNFT is Script {

    function run() external {
        address ccnftAddress = 0xd3482a9b5A5aB89174EA6475E06C68D772885bd7;
        bool canBuy = true; // compras de NFTs habilitadas
        bool canClaim = true; // reclamaciones de NFTs habilitadas
        bool canTrade = true; // transferencias de NFTs habilitadas
        uint256 maxValueToRaise = 2000000 * 10 ** 18; // valor máximo a recaudar (2,000,000 BUSD)
        uint16 buyFee = 200; // Tarifa de compra (2%).
        uint16 tradeFee = 300; // Tarifa de transferencia (3%).
        uint16 maxBatchCount = 12; // Límite inicial de NFTs por operación.
        uint16 profitToPay = 500; // Porcentaje inicial de beneficio a pagar en reclamaciones (5%).

        setSetsForCCNFTContract(ccnftAddress, canBuy, canClaim, canTrade, maxValueToRaise, buyFee, tradeFee, maxBatchCount, profitToPay);
    }

    function setSetsForCCNFTContract(address ccnftAddress, bool canBuy, bool canClaim, bool canTrade, uint256 maxValueToRaise, 
        uint16 buyFee, uint16 tradeFee, uint16 maxBatchCount, uint16 profitToPay) public {
        vm.startBroadcast();

        // Establecer los parámetros del contrato CCNFT
        CCNFT(ccnftAddress).setCanBuy(canBuy);
        CCNFT(ccnftAddress).setCanClaim(canClaim);
        CCNFT(ccnftAddress).setCanTrade(canTrade);
        CCNFT(ccnftAddress).setMaxValueToRaise(maxValueToRaise);
        CCNFT(ccnftAddress).setBuyFee(buyFee);
        CCNFT(ccnftAddress).setTradeFee(tradeFee);
        CCNFT(ccnftAddress).setMaxBatchCount(maxBatchCount);
        CCNFT(ccnftAddress).setProfitToPay(profitToPay);

        // Finalizar la transmisión
        vm.stopBroadcast();
    }

}

contract CCNFTClaimToken is Script {

    function run() external {
        address ccnftAddress = 0xd3482a9b5A5aB89174EA6475E06C68D772885bd7;
        uint256[] memory listTokenId = new uint256[](1);
        listTokenId[0] = 9;

        CCNFTClaimTokenContract(ccnftAddress, listTokenId);
    }

    function CCNFTClaimTokenContract(address ccnftAddress, uint256[] memory listTokenId) public {
        vm.startBroadcast();

        // Comprar tokens CCNFT
        CCNFT(ccnftAddress).claim(listTokenId);

        // Finalizar la transmisión
        vm.stopBroadcast();
    }
}   

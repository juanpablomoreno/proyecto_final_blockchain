// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {CCNFT} from "../src/CCNFT.sol";

contract DeployCCNFT is Script {

    function run() public returns (CCNFT) {
        // Inicio del broadcasting de la transacción
        vm.startBroadcast();

        // Desplegar el contrato CCNFT
        CCNFT ccnft = new CCNFT();

        // Fin del broadcasting
        vm.stopBroadcast();

        return ccnft;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {CCNFT} from "../src/CCNFT.sol";
import {BUSD} from "../src/BUSD.sol";

contract DeployCCNFT is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address fundsCollector = vm.envAddress("FUNDS_COLLECTOR");

        // Inicio del broadcasting de la transacción
        vm.startBroadcast(deployerPrivateKey);

        // Desplegar el contrato BUSD de prueba (en un entorno de test)
        BUSD busdToken = new BUSD();

        // Desplegar el contrato CCNFT, pasando la dirección del BUSD
        CCNFT ccnft = new CCNFT(address(busdToken));
        ccnft.transferOwnership(msg.sender);

        // Opcional: configurar otras variables en el contrato CCNFT
        ccnft.setFundsCollector(fundsCollector);
        // ... otras configuraciones

        // Fin del broadcasting
        vm.stopBroadcast();
    }
}

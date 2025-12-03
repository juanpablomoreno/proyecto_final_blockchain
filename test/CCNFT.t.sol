// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {BUSD} from "../src/BUSD.sol";
import {CCNFT} from "../src/CCNFT.sol";

import {DeployBUSD} from "../script/DeployBUSD.s.sol";
import {DeployCCNFT} from "../script/DeployCCNFT.s.sol";

// Definición del contrato de prueba CCNFTTest que hereda de Test. 
// Declaración de direcciones y dos instancias de contratos (BUSD y CCNFT).
contract CCNFTTest is Test {
    address deployer = address(1);
    address c1 = address(2);
    address c2  = address(3);
    address funds = address(4);
    address fees = address(5);
    
    CCNFT ccnft;
    BUSD busd;

// Ejecución antes de cada prueba. 
// Inicializar las direcciones y desplgar las instancias de BUSD y CCNFT.
    function setUp() public {
        busd = new BUSD();
        ccnft = new CCNFT();

        // Despliega el contrato CCNFT
        //deployer = new DeployCCNFT();
        // Garantizar que el contrato se despliegue correctamente
        //ccnft = deployer.run();

        // Despliega el contrato BUSD
        //busdDeployer = new DeployBUSD();
        // Garantizar que el contrato se despliegue correctamente
        //busd = busdDeployer.run();
    }

// Prueba de "setFundsCollector" del contrato CCNFT. 
// Llamar al método y despues verificar que el valor se haya establecido correctamente.
    function testSetFundsCollector() public {
        ccnft.setFundsCollector(funds);
        assertEq(ccnft.fundsCollector(), funds);
    }

// Prueba de "setFeesCollector" del contrato CCNFT
// Verificar que el valor se haya establecido correctamente.
    function testSetFeesCollector() public {
        ccnft.setFeesCollector(fees);
        assertEq(ccnft.feesCollector(), fees);
    }

// Prueba de "setProfitToPay" del contrato CCNFT
// Verificar que el valor se haya establecido correctamente.
    function testSetProfitToPay() public {
        ccnft.setProfitToPay(1000);
        assertEq(ccnft.profitToPay(), 1000);
    }

// Prueba de "setCanBuy" primero estableciéndolo en true y verificando que se establezca correctamente.
// Despues establecerlo en false verificando nuevamente.
    function testSetCanBuy() public {
        ccnft.setCanBuy(true);
        assertEq(ccnft.canBuy(), true);

        ccnft.setCanBuy(false);
        assertEq(ccnft.canBuy(), false);
    }

// Prueba de método "setCanTrade". Similar a "testSetCanBuy".
    function testSetCanTrade() public {
        ccnft.setCanTrade(true);
        assertEq(ccnft.canTrade(), true);

        ccnft.setCanTrade(false);
        assertEq(ccnft.canTrade(), false);
    }

// Prueba de método "setCanClaim". Similar a "testSetCanBuy".
    function testSetCanClaim() public {
        ccnft.setCanClaim(true);
        assertEq(ccnft.canClaim(), true);

        ccnft.setCanClaim(false);
        assertEq(ccnft.canClaim(), false);
    }

// Prueba de "setMaxValueToRaise" con diferentes valores.
// Verifica que se establezcan correctamente.
    function testSetMaxValueToRaise() public {
        ccnft.setMaxValueToRaise(5000);
        assertEq(ccnft.maxValueToRaise(), 5000);
        ccnft.setMaxValueToRaise(10000);
        assertEq(ccnft.maxValueToRaise(), 10000);
        ccnft.setMaxValueToRaise(15000);
        assertEq(ccnft.maxValueToRaise(), 15000);
    }

// Prueba de "addValidValues" añadiendo diferentes valores.
// Verificar que se hayan añadido correctamente.
    function testAddValidValues() public {
        ccnft.addValidValues(5000);
        assertEq(ccnft.validValues(5000), true);
        ccnft.addValidValues(10000);
        assertEq(ccnft.validValues(10000), true);
        ccnft.addValidValues(15000);
        assertEq(ccnft.validValues(15000), true);
    }

// Prueba de "setMaxBatchCount".
// Verifica que el valor se haya establecido correctamente.
    function testSetMaxBatchCount() public {
        ccnft.setMaxBatchCount(20);
        assertEq(ccnft.maxBatchCount(), 20);
    }

// Prueba de "setBuyFee".
// Verificar que el valor se haya establecido correctamente.
    function testSetBuyFee() public {
        ccnft.setBuyFee(15);
        assertEq(ccnft.buyFee(), 15);
    }

// Prueba de "setTradeFee".
// Verificar que el valor se haya establecido correctamente.
    function testSetTradeFee() public {
        ccnft.setTradeFee(25);
        assertEq(ccnft.tradeFee(), 25);
    }

// Prueba de que no se pueda comerciar cuando canTrade es false.
// Verificar que se lance un error esperado.
    function testCannotTradeWhenCanTradeIsFalse() public {
        ccnft.setCanTrade(false);
        vm.expectRevert(bytes("Trade is not allowed"));
        ccnft.trade(1);
    }

// Prueba que no se pueda comerciar con un token que no existe, incluso si canTrade es true. 
// Verificar que se lance un error esperado.
    function testCannotTradeWhenTokenDoesNotExist() public {
        ccnft.setCanTrade(true);
        vm.expectRevert(bytes("Token ID doesn't exists"));
        ccnft.trade(999);
    }
}

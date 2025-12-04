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
    address deployer;
    address c1;
    address c2;
    address funds;
    address fees;
    
    CCNFT ccnft;
    BUSD busd;

// Ejecución antes de cada prueba. 
// Inicializar las direcciones y desplgar las instancias de BUSD y CCNFT.
    function setUp() public {
        c1 = makeAddr("c1");
        c2 = makeAddr("c2");
        funds = makeAddr("funds");
        fees = makeAddr("feeds");

        // Despliega el contrato BUSD
        DeployBUSD deployBusd = new DeployBUSD();
        // Garantizar que el contrato se despliegue correctamente
        busd = deployBusd.run();

        // Despliega el contrato CCNFT
        DeployCCNFT deployCcnft = new DeployCCNFT();
        // Garantizar que el contrato se despliegue correctamente
        ccnft = deployCcnft.run();

        // Asignar la dirección del deployer (propietario) del contrato CCNFT
        deployer = ccnft.owner();

        vm.prank(deployer);
        // Asignar la dirección del contrato BUSD al contrato CCNFT como token de fondos
        ccnft.setFundsToken(address(busd));
    }

// Prueba de "setFundsCollector" del contrato CCNFT. 
// Llamar al método y despues verificar que el valor se haya establecido correctamente.
    function testSetFundsCollector() public {
        vm.prank(deployer);
        ccnft.setFundsCollector(funds);
        assertEq(ccnft.fundsCollector(), funds);
    }

// Prueba de "setFeesCollector" del contrato CCNFT
// Verificar que el valor se haya establecido correctamente.
    function testSetFeesCollector() public {
        vm.prank(deployer);
        ccnft.setFeesCollector(fees);
        assertEq(ccnft.feesCollector(), fees);
    }

// Prueba de "setProfitToPay" del contrato CCNFT
// Verificar que el valor se haya establecido correctamente.
    function testSetProfitToPay() public {
        vm.prank(deployer);
        ccnft.setProfitToPay(1000);
        assertEq(ccnft.profitToPay(), 1000);
    }

// Prueba de "setCanBuy" primero estableciéndolo en true y verificando que se establezca correctamente.
// Despues establecerlo en false verificando nuevamente.
    function testSetCanBuy() public {
        vm.startPrank(deployer);
        ccnft.setCanBuy(true);
        assertEq(ccnft.canBuy(), true);

        ccnft.setCanBuy(false);
        assertEq(ccnft.canBuy(), false);
        vm.stopPrank();
    }

// Prueba de método "setCanTrade". Similar a "testSetCanBuy".
    function testSetCanTrade() public {
        vm.startPrank(deployer);
        ccnft.setCanTrade(true);
        assertEq(ccnft.canTrade(), true);

        ccnft.setCanTrade(false);
        assertEq(ccnft.canTrade(), false);
        vm.stopPrank();
    }

// Prueba de método "setCanClaim". Similar a "testSetCanBuy".
    function testSetCanClaim() public {
        vm.startPrank(deployer);
        ccnft.setCanClaim(true);
        assertEq(ccnft.canClaim(), true);

        ccnft.setCanClaim(false);
        assertEq(ccnft.canClaim(), false);
        vm.stopPrank();
    }

// Prueba de "setMaxValueToRaise" con diferentes valores.
// Verifica que se establezcan correctamente.
    function testSetMaxValueToRaise() public {
        vm.startPrank(deployer);
        ccnft.setMaxValueToRaise(5000);
        assertEq(ccnft.maxValueToRaise(), 5000);
        ccnft.setMaxValueToRaise(10000);
        assertEq(ccnft.maxValueToRaise(), 10000);
        ccnft.setMaxValueToRaise(15000);
        assertEq(ccnft.maxValueToRaise(), 15000);
        vm.stopPrank();
    }

// Prueba de "addValidValues" añadiendo diferentes valores.
// Verificar que se hayan añadido correctamente.
    function testAddValidValues() public {
        vm.startPrank(deployer);
        ccnft.addValidValues(5000);
        assertEq(ccnft.validValues(5000), true);
        ccnft.addValidValues(10000);
        assertEq(ccnft.validValues(10000), true);
        ccnft.addValidValues(15000);
        assertEq(ccnft.validValues(15000), true);
        vm.stopPrank();
    }

// Prueba de "setMaxBatchCount".
// Verifica que el valor se haya establecido correctamente.
    function testSetMaxBatchCount() public {
        vm.prank(deployer);
        ccnft.setMaxBatchCount(20);
        assertEq(ccnft.maxBatchCount(), 20);
    }

// Prueba de "setBuyFee".
// Verificar que el valor se haya establecido correctamente.
    function testSetBuyFee() public {
        vm.prank(deployer);
        ccnft.setBuyFee(15);
        assertEq(ccnft.buyFee(), 15);
    }

// Prueba de "setTradeFee".
// Verificar que el valor se haya establecido correctamente.
    function testSetTradeFee() public {
        vm.prank(deployer);
        ccnft.setTradeFee(25);
        assertEq(ccnft.tradeFee(), 25);
    }

// Prueba de que no se pueda comerciar cuando canTrade es false.
// Verificar que se lance un error esperado.
    function testCannotTradeWhenCanTradeIsFalse() public {
        vm.prank(deployer);
        ccnft.setCanTrade(false);
        vm.expectRevert(bytes("Trade is not allowed"));
        ccnft.trade(1);
    }

// Prueba que no se pueda comerciar con un token que no existe, incluso si canTrade es true. 
// Verificar que se lance un error esperado.
    function testCannotTradeWhenTokenDoesNotExist() public {
        vm.prank(deployer);
        ccnft.setCanTrade(true);
        vm.expectRevert(bytes("Token ID doesn't exists"));
        ccnft.trade(999);
    }

    function testBuy() public {
        uint256 valueOfToken = 100 * 10 ** 18;
        uint16 amountToBuy = 2;
        uint16 buyFee = 200; // 2%

        // Asignar BUSD a c1
        vm.prank(deployer);
        busd.transfer(c1, 1000000 * 10 ** 18);
        assertEq(busd.balanceOf(c1), 1000000 * 10 ** 18);

        // Implementar la prueba de compra
        vm.prank(c1);
        busd.approve(address(ccnft), 1000000 * 10 ** 18);

        vm.startPrank(deployer);
        // Configurar el contrato CCNFT para permitir compras
        ccnft.setCanBuy(true);
        // Añadir un valor válido para la compra
        ccnft.addValidValues(100 * 10 ** 18);
        // Establecer los colectores de fondos y tarifas
        ccnft.setFundsCollector(funds);
        ccnft.setFeesCollector(fees);
        // Establecer las tarifas de compra y comercio
        ccnft.setBuyFee(buyFee);
        vm.stopPrank();

        vm.prank(c1);
        ccnft.buy(valueOfToken, amountToBuy);
        assertEq(ccnft.balanceOf(c1), amountToBuy);

        // Verificar los saldos de los colectores de fondos y tarifas
        vm.prank(deployer);
        uint256 feesCollected = busd.balanceOf(fees);
        console.log("Fees collected:", feesCollected);
        assertEq(feesCollected, (amountToBuy * valueOfToken) * buyFee / 10000);

        vm.prank(deployer);
        uint256 fundsCollected = busd.balanceOf(funds);
        console.log("Funds collected:", fundsCollected);
        assertEq(fundsCollected, (amountToBuy * valueOfToken));
    }

    function testTrade() public {
        uint256 valueOfToken = 100 * 10 ** 18;
        uint16 amountToBuy = 2;
        uint16 buyFee = 200; // 2%
        uint16 tradeFee = 300; // 3%

        // Asignar BUSD a c1
        vm.prank(deployer);
        busd.transfer(c1, 1000000 * 10 ** 18);
        assertEq(busd.balanceOf(c1), 1000000 * 10 ** 18);
        // Asignar BUSD a c2
        vm.prank(deployer);
        busd.transfer(c2, 1000000 * 10 ** 18);
        assertEq(busd.balanceOf(c2), 1000000 * 10 ** 18);

        // Implementar la prueba de compra
        // Aprobar el gasto de BUSD para c1 y c2
        vm.prank(c1);
        busd.approve(address(ccnft), 1000000 * 10 ** 18);
        vm.prank(c2);
        busd.approve(address(ccnft), 1000000 * 10 ** 18);

        vm.startPrank(deployer);
        // Configurar el contrato CCNFT para permitir compras y comercio
        ccnft.setCanBuy(true);
        ccnft.setCanTrade(true);
        // Añadir un valor válido para la compra
        ccnft.addValidValues(100 * 10 ** 18);
        // Establecer los colectores de fondos y tarifas
        ccnft.setFundsCollector(funds);
        ccnft.setFeesCollector(fees);
        // Establecer las tarifas de compra y comercio
        ccnft.setBuyFee(buyFee);
        ccnft.setTradeFee(tradeFee);
        vm.stopPrank();

        vm.prank(c1);
        ccnft.buy(valueOfToken, amountToBuy);
        assertEq(ccnft.balanceOf(c1), amountToBuy);


        // Verificar los saldos de los colectores de tarifas después del comercio
        vm.prank(deployer);
        uint256 feesCollected = busd.balanceOf(fees);
        console.log("Fees collected before trade:", feesCollected);
        //assertEq(feesCollected, (amountToBuy * valueOfToken) * 200 / 10000 + (valueOfToken * tradeFee / 10000));

        vm.prank(deployer);
        uint256 fundsCollected = busd.balanceOf(funds);
        console.log("Funds collected before trade:", fundsCollected);
        //assertEq(fundsCollected, (amountToBuy * valueOfToken) + (valueOfToken - (valueOfToken * tradeFee / 10000)) );



        // Ahora probar el comercio
        uint256 tokenIdToTrade = 1; // Suponiendo que el primer token tiene ID 1
        uint256 tradePrice = 150 * 10 ** 18; // Precio al que c2 comprará el token
        
        vm.prank(c1);
        ccnft.putOnSale(tokenIdToTrade, tradePrice);

        vm.prank(deployer);
        console.log("Before trade, c1 balance:", ccnft.balanceOf(c1));
        vm.prank(deployer);
        console.log("Before trade, c2 balance:", ccnft.balanceOf(c2));
        vm.prank(c2);
        ccnft.trade(tokenIdToTrade);


        vm.prank(deployer);
        console.log("After trade, c1 balance:", ccnft.balanceOf(c1));
        vm.prank(deployer);
        console.log("After trade, c2 balance:", ccnft.balanceOf(c2));

        vm.prank(deployer);
        assertEq(ccnft.balanceOf(c1), amountToBuy - 1);
        vm.prank(deployer);
        assertEq(ccnft.balanceOf(c2), 1);

        
        // Verificar los saldos de los colectores de tarifas después del comercio
        vm.prank(deployer);
        feesCollected = busd.balanceOf(fees);
        console.log("Fees collected after trade:", feesCollected);
        //assertEq(feesCollected, (amountToBuy * valueOfToken) * 200 / 10000 + (valueOfToken * tradeFee / 10000));

        vm.prank(deployer);
        fundsCollected = busd.balanceOf(funds);
        console.log("Funds collected after trade:", fundsCollected);
        //assertEq(fundsCollected, (amountToBuy * valueOfToken) + (valueOfToken - (valueOfToken * tradeFee / 10000)) );
        
    }
}

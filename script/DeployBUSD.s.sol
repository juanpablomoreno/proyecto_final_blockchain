// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BUSD} from "../src/BUSD.sol";

contract DeployBUSD is Script {
    function run() external returns (BUSD) {
        vm.startBroadcast();
        BUSD busd = new BUSD();

        vm.stopBroadcast();
        return busd;
    }
}
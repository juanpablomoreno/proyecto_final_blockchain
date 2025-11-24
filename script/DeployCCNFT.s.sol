// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {CCNFT} from "../src/CCNFT.sol";

contract DeployCCNFT is Script {
    function run() external returns (CCNFT) {
        vm.startBroadcast();
        CCNFT ccnft = new CCNFT();

        vm.stopBroadcast();
        return ccnft;
    }
}

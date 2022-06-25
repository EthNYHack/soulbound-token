// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Certificate.sol";

contract CertificateScript is Script {
    string name = "Soulbound Certificate";
    string symbol = "CERT";

    function run() public {
        vm.startBroadcast();
        new Certificate(name, symbol);
        vm.stopBroadcast();
    }
}

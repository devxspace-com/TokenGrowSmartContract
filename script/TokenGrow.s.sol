// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NFTToken.sol";
import "../test/utils/Token.sol";
import "../src/NFTToken.sol";

contract TokenGrow is Script {
    Token public token;


    function setUp() public {
        // token = new Token();
    }


    function run() public {
        // vm.broadcast();
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        token = new Token();

        vm.stopBroadcast();
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import "../src/NFTToken.sol";

contract CounterTest is Test {
    Counter public counter;
    NFTToken public nft;


    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
        nft = new NFTToken("Token_grow", "TG");
    }

function testMint() public{
   nft.mintNFT(msg.sender, "jjdjdjdjjddj");
   nft.mintNFT(msg.sender, "jjj");
   console.log( nft.tokenURI(1));
   console.log( nft.tokenURI(2));
}




    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }


}

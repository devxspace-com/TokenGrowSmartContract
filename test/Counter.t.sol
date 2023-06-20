// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import "../src/NFTToken.sol";
import "../src/GetPriceFeed.sol";
import "../src/TokenGrow.sol";
import "./utils/Token.sol";

contract CounterTest is Test {
    Counter public counter;
    NFTToken public nft;
    GetPriceFeed public priceFeed;
    TokenGrow public tokenGrow;
    Token public token;

    address _usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address _alice = address(100);
    address _vince = address(1220);
    address _nonso = address(120);


    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);

        nft = new NFTToken("Token_grow", "TG");

        priceFeed = new GetPriceFeed();
        token = new Token(_alice, _vince, _nonso);
        tokenGrow = new TokenGrow('tokenG', 'tg2', address(nft), address(token) );

    }

function testMint() public{
//    nft.mintNFT(msg.sender, "jj");
vm.startPrank(_alice);
   nft.mintNFT(_alice, "telnet://192.0.2.16:80");

   nft.mintNFT(_alice, "telnet://192.0.2.16:90");
    nft.approve(address(tokenGrow), 0);
   tokenGrow.createInvestment(0, _alice, 20, 5000, 5 minutes);
    nft.approve(address(tokenGrow), 1);
   tokenGrow.createInvestment(1, _alice, 40, 5000, 10 minutes);

   tokenGrow.getAllInvestment();
   vm.stopPrank();

   token.balanceOf(_nonso);
vm.prank(_nonso);
token.approve(address(tokenGrow), 20000);

vm.prank(_nonso);
   tokenGrow.buyAnInvestment(200, 0,  _nonso);
   
vm.prank(_vince);
token.approve(address(tokenGrow), 20000);
vm.prank(_vince);
   tokenGrow.buyAnInvestment(500, 0,  _vince);
vm.prank(_nonso);
   tokenGrow.buyAnInvestment(4500, 1,  _nonso);

// vm.prank(_vince);
//    tokenGrow.buyAnInvestment(500, 1,  _vince);
vm.prank(_vince);
tokenGrow.getYourInvestment(_vince);

vm.prank(_nonso);
tokenGrow.getYourInvestment(_nonso);

vm.prank(_alice);
tokenGrow.startInvestment(0, _alice);

vm.prank(_alice);
tokenGrow.checkCreatorInvestment(_alice);

vm.prank(_alice);
tokenGrow.withdrawtheInvestment(_alice, 1, 4500);

vm.prank(_alice);
// tokenGrow.withdrawtheInvestment(_alice, 1, 1000);
tokenGrow.payBack(1, _alice);

vm.prank(_alice);
token.approve(address(tokenGrow), 20000);
vm.prank(_alice);
tokenGrow.returnFundWithInterest(1, _alice, 6300);

vm.warp(20 minutes);
vm.prank(_nonso);
tokenGrow.withDrawInvestment(1, _nonso);

vm.warp(20 minutes);
vm.prank(_nonso);
tokenGrow.withDrawInvestment(1, _nonso);

// tokenGrow.balanceOf(_nonso);
//    console.log( nft.tokenURI(1));
//    console.log( nft.tokenURI(2));
}




    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }


}

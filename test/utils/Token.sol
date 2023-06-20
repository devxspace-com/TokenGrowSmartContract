// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
contract Token is ERC20{

constructor(address addr, address addr2, address addr3) ERC20("testToken", 'TT'){
 _mint(addr, 2000);
 _mint(addr2, 5000);
 _mint(addr3, 10000000000000000000000);
}
}
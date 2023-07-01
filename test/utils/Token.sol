// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
contract Token is ERC20{

constructor() ERC20("USDTtestToken", 'UST'){

}
function mintoken() public {
    _mint(msg.sender, 2000 * 1e18);
}
}
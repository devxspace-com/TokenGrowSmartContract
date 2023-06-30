# Token_Grow App Documentation

## Overview

Token_Grow is a decentralized application (DApp) built on the Ethereum blockchain. It allows users to create and invest in investment agricultural opportunities represented by ERC20 tokens. Each investment is associated with a specific ERC721 token (NFT) and offers a certain percentage return on investment (ROI) within a defined investment period.

This documentation provides an overview of the Token_Grow smart contract, its functionalities, and how users can interact with the DApp.

## Smart Contract Details

The Token_Grow smart contract is implemented in Solidity and follows the ERC20 standard. It extends the ERC20 contract from the OpenZeppelin library and also interacts with the ERC721 contract. The contract uses the `Counters` library for generating unique investment IDs.

## Contract address: 
[0x7d23ad726af604de5bd9cd2fba9030f6a45185b6]

## deployment

https://testnet.ftmscan.com/address/0xee40081bb47be32fc6ffb810b26ceacc8d40b2b1


## Contract Structure

The Token_Grow smart contract consists of the following main components:

1. **Constructor**
   - Initializes the contract by setting the token name, symbol, and addresses of the ERC721 contract and payment token contract.

2. **Structs**
   - `Investment`: Represents an investment opportunity. Contains various properties such as investment owner, ID, associated ERC721 token ID, percentage ROI, token amounts, investment periods, and more.

3. **State Variables**
   - `_investmentCounter`: A counter for generating unique investment IDs.
   - `_nftCollection`: Reference to the ERC721 contract.
   - `_paymentToken`: Reference to the ERC20 payment token contract.
   - `_id`: Current investment ID.

4. **Mappings**
   - `investment`: Maps investment IDs to `Investment` structs.
   - `_totalInvestmentCreated`: Maps investment owners to their investment IDs.
   - `_myInvestmentId`: Maps investors to their investment IDs.

5. **Functions**
   - `createInvestment`: Allows the investment owner to create a new investment opportunity associated with a specific ERC721 token.
   - `startInvestment`: Allows the investment owner to start an investment period.
   - `getAllInvestment`: Retrieves information about all investments created, including investment IDs, associated token IDs, ROI percentages, token amounts, investment periods, and more.
   - `buyAnInvestment`: Allows investors to buy an investment opportunity by depositing the required amount of payment tokens.
   - `getYourInvestment`: Retrieves information about investments made by a specific investor, including investment IDs, associated token IDs, total amounts invested, and total tokens purchased.
   - `withDrawInvestment`: Allows investors to withdraw their investment along with the ROI after the investment period ends.
   - `checkCreatorInvestment`: Retrieves information about investments created by a specific investment owner, including investment IDs, associated token IDs, ROI percentages, token amounts, investment periods, and more.
   - `withdrawtheInvestment`: Allows the investment owner to withdraw the deposited payment tokens from an investment.
   - `payBack`: Calculates the total amount to be paid back by an investor, including the invested amount and ROI.
   - `returnFundWithInterest`: Allows the investment owner to return the invested amount and ROI to an investor.

## Interacting with the Token_Grow DApp

The Token_Grow DApp can be interacted with using the following functions:

### `createInvestment`

This function allows the investment owner to create a new investment opportunity.

```solidity
function createInvestment(
    uint256 _tokenId,
    address _owner,
    uint _percent,
    uint _tokenAmount,
    uint _investmentEndTime
) public
```

- `_tokenId`: The ID of the ERC721 token associated with the investment.
- `_owner`: The address of the investment owner.
- `_percent`: The percentage return on investment (ROI) offered by the investment opportunity.
- `_tokenAmount`: The amount of ERC20 tokens required to invest in the opportunity.
- `_investmentEndTime`: The end time of the investment period.

### `startInvestment`

This function allows the investment owner to start the investment period for a specific investment.

```solidity
function startInvestment(uint256 _investmentId) public
```

- `_investmentId`: The ID of the investment to start.

### `getAllInvestment`

This function retrieves information about all investments created, including investment IDs, associated token IDs, ROI percentages, token amounts, investment periods, and more.

```solidity
function getAllInvestment() public view returns (Investment[] memory)
```

### `buyAnInvestment`

This function allows investors to buy an investment opportunity by depositing the required amount of payment tokens.

```solidity
function buyAnInvestment(uint256 _investmentId) public payable
```

- `_investmentId`: The ID of the investment to buy.

### `getYourInvestment`

This function retrieves information about investments made by a specific investor, including investment IDs, associated token IDs, total amounts invested, and total tokens purchased.

```solidity
function getYourInvestment(address _investor) public view returns (Investment[] memory)
```

- `_investor`: The address of the investor.

### `withDrawInvestment`

This function allows investors to withdraw their investment along with the ROI after the investment period ends.

```solidity
function withDrawInvestment(uint256 _investmentId) public
```

- `_investmentId`: The ID of the investment to withdraw from.

### `checkCreatorInvestment`

This function retrieves information about investments created by a specific investment owner, including investment IDs, associated token IDs, ROI percentages, token amounts, investment periods, and more.

```solidity
function checkCreatorInvestment(address _owner) public view returns (Investment[] memory)
```

- `_owner`: The address of the investment owner.

### `withdrawtheInvestment`

This function allows the investment owner to withdraw the deposited payment tokens from an investment.

```solidity
function withdrawtheInvestment(uint256 _investmentId) public
```

- `_investmentId`: The ID of the investment to withdraw from.

### `payBack`

This internal function calculates the total amount to be paid back by an investor, including the invested amount and ROI.

```solidity
function payBack(uint256 _investmentId, uint256 _investorIndex) internal view returns (uint256)
```

- `_investmentId`: The ID of the investment.
- `_investorIndex`: The index of the investor.

### `returnFundWithInterest`

This function allows the investment owner to return the invested amount and ROI to an investor.

```solidity
function returnFundWithInterest(uint256 _investmentId, uint256 _investorIndex) public
```

- `_investmentId`: The ID of the investment.
- `_investorIndex`: The index of the investor.

## Conclusion

This documentation provides an overview of the Token_Grow smart contract and its functionalities. Users can create investment opportunities, invest in them, and withdraw their investments along with the ROI. The contract provides transparency and security by leveraging the Ethereum blockchain. Please note that this documentation provides a high-level summary, and it's important to refer to the actual smart contract code for detailed implementation and specific function parameters.
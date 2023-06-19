// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";
import {GetPriceFeed} from "./GetPriceFeed.sol";

contract TokenGrow is ERC20 {
    using Counters for Counters.Counter;

    Counters.Counter private _investmentCounter;
    IERC721 private _nftCollection;
    ERC20 private _paymentToken;

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        address _nftAddr,
        address _payment
    ) ERC20(_tokenName, _tokenSymbol) {
        _nftCollection = IERC721(_nftAddr);
        _paymentToken = ERC20(_payment);
    }

    struct Investment {
        address investmentOwner;
        uint tokenId;
        uint percent;
        uint tokenAmount;
        uint tokenSold;
        uint tokenLeft;
        uint startInvestmentPeriod;
        uint endInvestmentPeriod;
        uint totalInvestors;
        uint tokenToSellLimit;
        //totalAmountPaidToInvestor
        uint totalAmount;
        // amount withdraw
        uint amountWithdraw;
        //Amount paid back by investor
        uint amountDeposited;
        mapping(address => uint) amountInvested;
        // Token purchased by the investor
        mapping(address => uint) tokenPurchased;
    }

    mapping(uint => Investment) public investment;
    //to keep track of the total invetmentId in the contract
    uint[] public tokenIds;
    //to keep track of all the investment created by each address
    mapping(address => uint[]) _totalInvestmentCreated;

    // to keep track of each investors investment Id
    mapping(address => uint[]) _myInvestmentId;

    /**
     *function to create Investment
     *Each token minted is equated to 1$
     *Minted token shows the total investment rate at the percentage said
     */
    function createInvestment(
        uint256 _tokenId,
        address _owner,
        uint _percent,
        uint _tokenAmount,
        uint _investmentEndTime
    ) public {
        if (msg.sender != _owner) revert();
        if (_nftCollection.balanceOf(msg.sender) < 0) revert();
        if (_nftCollection.ownerOf(_tokenId) != _owner) revert();

        //to save the specific Id
        uint tokenIdSave = tokenIds.length;
        _nftCollection.safeTransferFrom(msg.sender, address(this), _tokenId);

        Investment storage newInvestment = investment[
            _investmentCounter.current()
        ];
        newInvestment.tokenId = _tokenId;
        newInvestment.percent = _percent;
        newInvestment.tokenAmount = _tokenAmount;
        newInvestment.endInvestmentPeriod = _investmentEndTime;
        newInvestment.tokenLeft = _tokenAmount;

        tokenIds.push(tokenIdSave);
        _totalInvestmentCreated[_owner].push(tokenIdSave);
    }

    /**
    * Start your investment
    */ 
    function startInvestment(uint _investmentId, address _investmentOwner) public{
        if(msg.sender != _investmentOwner ) revert();
          Investment storage startInvest = investment[
            _investmentId];
            if(_investmentOwner != startInvest.investmentOwner) revert();
            startInvest.startInvestmentPeriod = block.timestamp;

    }

    /**
     *To display the investment registered
     */

    function getAllInvestment()
        public
        view
        returns (
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory
        )
    {
        uint length = tokenIds.length;

        // address[] memory owners = new address[](length);
        uint[] memory tokenIdsArr = new uint[](length);
        uint[] memory percents = new uint[](length);
        uint[] memory tokenAmounts = new uint[](length);
        uint[] memory tokenSolds = new uint[](length);
        uint[] memory tokenLefts = new uint[](length);
        uint[] memory startInvestmentPeriods = new uint[](length);
        uint[] memory endInvestmentPeriods = new uint[](length);

        for (uint i = 0; i < length; i++) {
            uint tokenIdSave = tokenIds[i];
            Investment storage currentInvestment = investment[tokenIdSave];

            tokenIdsArr[i] = currentInvestment.tokenId;
            percents[i] = currentInvestment.percent;
            tokenAmounts[i] = currentInvestment.tokenAmount;
            tokenSolds[i] = currentInvestment.tokenSold;
            tokenLefts[i] = currentInvestment.tokenLeft;
            startInvestmentPeriods[i] = currentInvestment.startInvestmentPeriod;
            endInvestmentPeriods[i] = currentInvestment.endInvestmentPeriod;
        }

        return (
            tokenIdsArr,
            percents,
            tokenAmounts,
            tokenSolds,
            tokenLefts,
            startInvestmentPeriods,
            endInvestmentPeriods
        );
    }

    /**
     *To buy Investment
     */
    function buyAnInvestment(
        uint _amount,
        uint _investmentId,
        address _priceFeedAddr,
        address _investor,
        uint _amountToPay
    ) public {
        if (msg.sender != _investor) revert();
        Investment storage purchaseInvestment = investment[_investmentId];

        if (purchaseInvestment.tokenSold >= purchaseInvestment.tokenAmount)
            revert();

        int currentPrice = GetPriceFeed(_priceFeedAddr).getLatestData();

        uint amounttoPurchase = uint(currentPrice) * _amount;

        if(_amountToPay != amounttoPurchase) revert();
        if (_amount > purchaseInvestment.tokenLeft) revert();
        _paymentToken.transfer(address(this), amounttoPurchase);

        purchaseInvestment.amountInvested[_investor] = amounttoPurchase;
        purchaseInvestment.tokenPurchased[_investor] = _amount;
        purchaseInvestment.totalAmount += amounttoPurchase;
        purchaseInvestment.tokenSold += _amount;
        purchaseInvestment.tokenLeft -= _amount;
        _myInvestmentId[_investor].push(_investmentId);
        _mint(_investor, _amount);
    }

    /**
     *To get the investors investment
     */

    function getYourInvestment(
        address _address
    ) public view returns (uint[] memory, uint[] memory) {
        uint[] memory investmentIds = _myInvestmentId[_address];

        uint[] memory totalAmountInvested = new uint[](investmentIds.length);
        uint[] memory totalTokenPurchased = new uint[](investmentIds.length);

        for (uint i = 0; i < investmentIds.length; i++) {
            uint investmentId = investmentIds[i];

            Investment storage investmentData = investment[investmentId];

            totalAmountInvested[i] = investmentData.amountInvested[_address];
            totalTokenPurchased[i] = investmentData.amountInvested[_address];
        }

        return (totalAmountInvested, totalTokenPurchased);
    }

    /**
     * To withdraw the investment of each users
     */
    function withDrawInvestment(
        uint _investmentId,
        address _investorAddr
    ) public {
        if (_investorAddr != msg.sender) revert();

        Investment storage getProfit = investment[_investmentId];

        if (block.timestamp != getProfit.endInvestmentPeriod) revert();

        uint amountDeposited = getProfit.amountInvested[_investorAddr];
        uint tokenBought = getProfit.tokenPurchased[_investorAddr];
        if (amountDeposited == 0) revert();
        if (tokenBought == 0) revert();
        if (getProfit.amountDeposited == 0) revert();
        uint incomePercent = getProfit.percent;

        uint calcPercent = (incomePercent * tokenBought) / 100;

        uint amounttoPay = calcPercent + amountDeposited;

        _paymentToken.transferFrom(address(this), _investorAddr, amounttoPay);
        getProfit.amountInvested[_investorAddr] = 0;
        getProfit.tokenPurchased[_investorAddr] = 0;
        _burn(_investorAddr, tokenBought);
    }

    /**
     * To check The investment created by the investor
     */
    function checkCreatorInvestment(
        address _creatorAddr
    )
        public
        view
        returns (
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory,
            uint[] memory
        )
    {
        if (msg.sender != _creatorAddr) revert();
        uint[] memory creatorIds = _totalInvestmentCreated[_creatorAddr];

        uint[] memory _tokenId = new uint[](creatorIds.length);
        uint[] memory _percent = new uint[](creatorIds.length);
        uint[] memory _tokenAmount = new uint[](creatorIds.length);
        uint[] memory _tokenSold = new uint[](creatorIds.length);
        uint[] memory _endPeriod = new uint[](creatorIds.length);
        uint[] memory _amountwithdraw = new uint[](creatorIds.length);
        uint[] memory _amountDeposited = new uint[](creatorIds.length);

        for (uint i = 0; i < creatorIds.length; i++) {
            uint creatorId = creatorIds[i];

            Investment storage investmentData = investment[creatorId];
            _tokenId[i] = investmentData.tokenId;
            _tokenAmount[i] = investmentData.tokenAmount;
            _tokenSold[i] = investmentData.tokenSold;
            _endPeriod[i] = investmentData.endInvestmentPeriod;
            _amountwithdraw[i] = investmentData.amountWithdraw;
            _amountDeposited[i] = investmentData.amountDeposited;
        }
        return (
            _tokenId,
            _percent,
            _tokenAmount,
            _tokenSold,
            _endPeriod,
            _amountwithdraw,
            _amountDeposited
        );
    }

    /**
     * To withdraw The Money deposited by the investors for the business
     */

    function withdrawtheInvestment(
        address _investmentOwner,
        uint _investmentId,
        uint withdraw
    ) public {
        if (msg.sender != _investmentOwner) revert();
        Investment storage fundWithdraw = investment[_investmentId];
        if (_investmentOwner != fundWithdraw.investmentOwner) revert();
        if (fundWithdraw.totalAmount == fundWithdraw.amountWithdraw) revert();
        if ((withdraw + fundWithdraw.amountWithdraw) > fundWithdraw.totalAmount)
            revert();

        fundWithdraw.amountWithdraw += withdraw;

        _paymentToken.transferFrom(address(this), _investmentOwner, withdraw);
    }

    /**
     *Amount to pay back
     */
    function payBack(
        uint _investmentId,
        address _investmentOwner
    ) public view returns (uint) {
        if (msg.sender != _investmentOwner) revert();

        Investment storage getFee = investment[_investmentId];
        if(_investmentOwner != getFee.investmentOwner) revert();
        uint _percent = getFee.percent;
        uint amount = getFee.totalAmount;

        uint rate = (amount * _percent) / 100;
        uint total = rate + amount;
        return total;
    }

    /**
     *To return the money wihdraw by the investor and the interest
     */

    function returnFundWithInterest(uint _investmentId, address _investmentOwner, uint _amount) public {
        uint amountToPay = payBack(_investmentId, _investmentOwner);
        if(_amount != amountToPay) revert();
        _paymentToken.transfer(address(this), amountToPay);
         Investment storage getFee = investment[_investmentId];
         getFee.amountDeposited += amountToPay;


    }
}

// SPDx-License-Identifeir: MIT

pragma solidity ^0.8.18;
import "../lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract GetPriceFeed {

    AggregatorV3Interface internal _dataFeed;

      address _priceFeed = 0xA2F78ab2355fe2f984D808B5CeE7FD0A93D5270E;

    /**
     * Network: Sepolia
     * Aggregator: BTC/USD
     * Address: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
     */

    constructor() {
        _dataFeed = AggregatorV3Interface(
            _priceFeed
        );
    }

        function getLatestData() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = _dataFeed.latestRoundData();
        return answer;
      
        }
}
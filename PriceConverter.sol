// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// importing from GetHub & NPM package to interact with contract outside of our project
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// libraries can't have state variable and can't send ether / all the function in libraries are "internal"
// we gonna make diffrenet functions we can call on "uint256"
library PriceConverter {
    // create a function to get a price of ETH in term of USD / using chain link data feeds to get the price
    function getPrice() internal view returns (uint256) {
        //we need the "Address" and the "ABI" of the contract to interact with contracts outside of our project
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 price, , , ) = priceFeed.latestRoundData(); // "int256" because some data could be negative
        return uint256(price * 1e10); //return the price of ETH in term of USD by converting the msg.value from ETH to terms of USD
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.version(); // call the function on the interface of the contract
    }

    // create a fuction to convert the rate (how much ETH is in terms of USD)
    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18; // always multipli before you divide
        return ethAmountInUSD;
    }
}

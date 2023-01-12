// SPDX-License-Identifier: MIT

/* WHAT WE ARE GOING TO DO IS:
#- Get funds from users
#- withdraw funds
#- set a minimum funding value in USD */

pragma solidity ^0.8.8;
// we took the functions (getPrice, getVersion, getConversionRate) and the "import" to our library (PriceConverter.sol)
import "./PriceConverter.sol";

// constant & immutable are (gas optimizations)
// another way to make this contract a bit more gas efficient, by updating our "requires" with creating a (custom error)
error NotOwner();

contract FundMe {
    using PriceConverter for uint256; // and attach it to "uint256"
    uint256 public constant MINIMUN_USD = 50 * 1e18;
    // 23,459 - none constant | 23,459 * 12000000000 = 281,508,000,000,000 = $0.844524 (gas execution cost)
    // 21,359 - constant | 21,359 * 12000000000 =  256,308,000,000,000 = $0.768924 (gas execution cost)
    // create data structurs to keep track of ppl sending fund to this contract/ we need to create an [Array]
    address[] public funders;
    // mapping: to check how much money each one of these ppl actually sent
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner; // create a global variable

    /* constructor is a function gets called immediately whenever the owner deploy a contract,
       and it set up who the owner of the contract is */
    constructor() {
        i_owner = msg.sender; //msg.sender of the construction function is gonna be whomever is deploying the contract
    }

    // mark the function as "payable" iin order to make it payable with ETH or other native blockchain currency
    function fund() public payable {
        // "require" statement to take an action/using a global keyword "msg.value" to get how much value somebody sending
        require(
            msg.value.getConversionRate() >= MINIMUN_USD,
            "Didn't send enough"
        ); //1e18 == 1 * 10 ** 18 = 1000000000000000000
        // anytime somebody send money will add funders into a list
        funders.push(msg.sender); // msg.sender is a global keyword we use for the address of whoever calls fund function
        // and when somebody fund our contract we say:
        addressToAmountFunded[msg.sender] += msg.value;
    }

    //withdraw the fund out of this contract, and reset funders array and "addressToAmountFunded" to go back down to (0)
    // to do so,  we need to loop through "funders" array and update "mapping" object
    function withdraw() public onlyOwner {
        /* starting index, ending index, step amount*/
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; // we reset the balances of the "mapping"
        }
        // now we reset the [array]
        //instade odf looping through the array and deleting objects, we gonna refresh the variable "funders"
        funders = new address[](0); // now funders variable has a new address array with 0 object in it to start

        // withdraw the funds with 3 ways (transfer, send, call)
        // transfer the funds to whomever is calling the "withdraw" function
        // in solidity in order to send native blockchain token, you can oly work with "payable address"
        // payable (msg.sender).transfer(address(this).balance);//we wrap the address we want to send it in, in "payable" keyword
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }(""); // call allows to call diffrenet function
        require(callSuccess, "Call failed");
    }

    // create a keyword called "modifier" which allows only owner in the withraw function declaration call the function
    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Sender is not owner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        } // replacing "require" with "if" statment
        _; // this underscore represent doing the rest of the code after the doing the "require statement"
    }

    /* we use spcial function if somebody send money without calling the "fund" function,
    we can still process the transaction */
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}

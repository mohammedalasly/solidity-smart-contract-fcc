// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory {
    // save the function "createSimpleStorageContract" to a global variable
    // using [Array] to keep track of all of our simple storage deployments
    SimpleStorage[] public simpleStorageArray; // variable, visibilty, and the name of the variable

    // create a function to deploy our "SimpleStorage Contract"
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage(); // using "new" keyword to diploy new "SimpleStorage contract"
        simpleStorageArray.push(simpleStorage);
    }

    //crate a function to intract with our simple storage deployments
    function sfStore(
        uint256 _simpleStorageIndex,
        uint256 _simpleStorageNumber
    ) public {
        // to intract with any contract we always gonn need the Address and the ABI(Aplication Binary Interface)
        // to call the "Store" function on one of our contracts, we need the contract Object
        // call our "store"function on the simple storage contract
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber); //using the Address of the simple storage object
    }

    // create a function to read form the simple storage contract from the storage factory
    // using the keyword "view" to read
    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return simpleStorageArray[_simpleStorageIndex].retrieve(); //call the "retrieve function on the simple storage object"
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// ExtraStorage contract is a childe contract of our simple storage contract
// we will have our extra storage inherit all the functionality of our simple storage
import "./SimpleStorage.sol"; // import other contract

// importing and using the keyword "is" to inherit all the functionality of another contract
contract ExtraStorage is SimpleStorage {
    // store and inherit function using 2 keywords (virtual in the parent contract and override in the childe contract)
    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber = 5;
    }
}

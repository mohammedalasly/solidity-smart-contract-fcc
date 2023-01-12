// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17; // adding the solidity version to start a smart contract

// adding "^" caret to till solidity that any version from 0.8.7 and above is alwwoed to be used
// pragma solidity >=0.8.7 <0.9.0; to use solidity version between a cpecific range
// examples of EVM compatible blockchains: Avalanche, Fantom, Polygon

contract SimpleStorage {
    // most basic types are: Boolean, uint, int, address, bytes

    uint256 favoriteNumber; // by adding public, we are adding a function that returns this favoriteNumber
    //people public person = people({favoriteNumber: 2, name: "Mohammad"});
    //Mapping:
    mapping(string => uint256) public nameToFavoriteNumber;
    // we use "struct" to store a range of favorite number of different ppl have different favnumber as an Object
    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // the other way is to use Array to list range of favorite number of different ppl have different favnumber
    // uint256[] public favoritesNumbersList;
    // dynamic Array
    People[] public people;

    // in order for a function to be overridable, we need to add the "virtual keyword" to the store function
    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
        // favoriteNumber = favoriteNumber + 1;
        //uint256 testVar = 5;
    }

    // view, pure functions disallow modification of state, pure function additionally disallow reading from blockchain state
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    // this is a pure function example
    // function add() public pure returns(uint256){
    //     return (1 + 1);
    //}

    //Adding a function who are people Array  using "memory, or calldata"
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        //people.push(People(_favoriteNumber, _name)); // Adding new people
        //another way to add new people using push array
        //People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        //people.push(newPerson);
        // another way
        // People memory newPerson = People(_favoriteNumber, _name);
        // people.push(newPerson);
        // another way to add a new person without using the key word "memory"
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

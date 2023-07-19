// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
    function hello() public view returns (string memory){
        return 'hello world';
    }
    
}
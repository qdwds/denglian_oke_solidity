//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Greeter {
    string public counter;
    uint256 public val;

    constructor(string memory _counter) {
        counter = _counter;
    }

    function count() public payable returns (uint256) {
        val += 1;
        return val;
    }
}

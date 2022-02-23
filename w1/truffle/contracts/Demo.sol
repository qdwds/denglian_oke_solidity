// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Demo {
  string public name = "hello world";

  function setName(string memory _name) public payable returns(string memory) {
    name = _name;
    return name;
  }
}

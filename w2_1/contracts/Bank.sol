//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Bank {
   mapping(address => uint256) balance;

   function withdraw(uint256 _val)public payable {
       require(_val > 0, "val");
       payable(msg.sender).transfer(balance[msg.sender]);
       balance[msg.sender] = 0;
   }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Demo{
    address public owner;
    uint256 public totalSupply;
    
    string public name = "Test demo";
    string public symbol = "TD";
    
    modifier isOwner (){
        require(msg.sender == owner, "You not an admin !");
        _;
    }
    mapping(address => uint256) public balanceOf;
    constructor(uint256 _totalSupply){
        owner = msg.sender;
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
    }

    function transfer(address _addr, uint256 _val) public isOwner payable returns(bool) {
        require(msg.sender != _addr, "rohibit !");
        require(_addr!= address(0), "Please check the address !");
        require(balanceOf[msg.sender] >= _val && _val > 0, "Sorry, your credit is running low !");
        balanceOf[msg.sender] -= _val;
        balanceOf[_addr] += _val;
        return true;
    }
}
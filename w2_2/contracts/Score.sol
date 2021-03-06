//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
/**
    通过接口的方式。使用一个合约调用另一个合约
 */

interface IScore{
    function increment(address _addr, uint8 _val) external;
    function decrement(address _addr, uint8 _val) external; 
    function setScore(address _addr, uint8 _val) external;
}

contract Score is IScore{
    mapping(address => uint8) public scores;
    address public conAddr;

    constructor(address _conAddr){
        conAddr = _conAddr;
    }
    //  校验合约
    modifier _isTeacherContract {
        require(msg.sender == conAddr,"contract ok ?");
        _;
    }
    function increment(address _addr, uint8 _val) external _isTeacherContract{
        require(scores[msg.sender] + _val <= 100, "Cannot exceed 100 !");
        scores[_addr] += _val;
    }

    function decrement(address _addr, uint8 _val) external _isTeacherContract{
        require(_val <= 100 && _val >= 0, "number ?");
        scores[_addr] -= _val;
    }

    function setScore(address _addr, uint8 _val) external _isTeacherContract{
        require(scores[_addr] <= 100, "Cannot exceed 100 !");
        scores[_addr] = _val;
    }

}

//  老师合约 使用接口的方式 设置学生成绩
contract Teacher{
    IScore score;
    address public teacher;

     event asd(address aa,address addres);
    constructor(){
        teacher = msg.sender;
        score = new Score(address(this));
    }
    //  校验调用者
    modifier _isTeacher{
        require(msg.sender == teacher,"Is teacher ?");
        _;
    }
    
    function increment(address _addr, uint8 _val) public _isTeacher  {
        score.increment(_addr, _val);
    }
    
    function decrement(address _addr, uint8 _val) public _isTeacher  {
        score.decrement(_addr, _val);
    }

    function setScore(address _addr, uint8 _val) public _isTeacher  {
        score.setScore(_addr, _val);
    }
}
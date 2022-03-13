//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from,address to,uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MyToken is IERC20{
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    uint256 private totalSupplys;
    address private onlyOwner;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowances;

    modifier _onlyOwner{
        require(msg.sender == onlyOwner, "Ownable: caller is not the owner");
        _;
    }
    
    constructor(string memory _name, string memory _symbol){
        onlyOwner = msg.sender;
        name = _name;
        symbol = _symbol;
        totalSupplys = 0;
    }
    function totalSupply()public view override returns(uint256){
        return totalSupplys;
    }
 
    function balanceOf(address account)public view override returns(uint256) {
        return balances[account];
    }
    function transfer(address to, uint256 amount)public override returns(bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function transferFrom(address from,address to,uint256 _amount) public override returns (bool) {
        _transfer(from, to, _amount);
        console.log(from, to, _amount);
        uint256 current =  allowance(from, to);
        require(current >= _amount,"ERC20: insufficient allowance");
        allowances[from][to] -= _amount;

        return true;
    }
    function approve(address spender, uint256 amount) public override returns(bool){
        _approve(tx.origin, spender, amount);
        console.log(tx.origin, spender, amount);
        return true;
    }
    function allowance(address owner, address spender) public view override returns(uint256){
        return allowances[owner][spender];
    }

    function incrementTotalSupply(address to, uint256 _amount) public _onlyOwner returns(bool) {
        console.log(to, _amount);
        require(to != address(0),"");
        totalSupplys += _amount;
        balances[to] += _amount;

        emit Transfer(msg.sender, to, _amount);
        return true;
    }

    function decrementTotalSupply(address to, uint256 _amount) public _onlyOwner returns(bool){
        require(to != address(0),"");
        require(balances[to] >= _amount,"");
        balances[to] -= _amount;
        totalSupplys -= _amount;

        emit Transfer(msg.sender, to, _amount);
        return true;
    }
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balances[from] >= amount,"ERC20: transfer amount exceeds balance");
        
        balances[from] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual{
        require(owner != address(0), "ERC20: transfer from the zero address");
        require(spender != address(0), "ERC20: transfer to the zero address");
        require(balances[owner] >= amount,"3");

        allowances[owner][spender] += amount;
        emit Approval(owner, spender, amount);
    }
}

contract Vault{
    //  erc20代币存入，记录每个用户存款余额。
    mapping(address => uint256) public vaultAll;
    uint256 public totalSupply;
    address public token;
    constructor(address _token){
        token = _token;
    }

    function deposite(uint256 _amount) public payable returns(bool){
        require(IERC20(token).transferFrom(msg.sender, address(this), _amount),"Vault: Transaction failure!");
        vaultAll[msg.sender] += _amount;
        totalSupply += _amount;
        return true;
    }
    //  给合约授权
    function approveForm(uint256 _amount) public payable returns(bool){
        require(IERC20(token).approve(address(this), _amount),"Vault: privilege grant failed !");

        return true;
    }
    //  提取自己存款
    function withdraw(address to, uint256 _amount) public payable returns(bool){
        require(to != address(0),"address is null !");
        require(vaultAll[msg.sender] >= _amount, "Vault: The balance is unstable !");
        vaultAll[msg.sender] -= _amount;
        totalSupply -= _amount;
        return true;
    }
}
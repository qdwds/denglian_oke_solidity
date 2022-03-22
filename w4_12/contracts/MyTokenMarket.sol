// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract MyTokenMarket {
    address public token;   //  需要田间流动性的token地址
    address public router;  //  路由地址
    address public weth;    //  weth

    constructor(address _token, address _router, address _weth){
        token = _token;
        router = _router;
        weth = _weth;
    }
    // 函数内部调用 UniswapV2Router 添加 MyToken 与 ETH 的流动性
    function AddLiquidity(uint256 _amount) public payable{
        IERC20(token).transferFrom(msg.sender, address(this), _amount);
        IERC20(token).approve(router, _amount);
        console.log(router);
        IUniswapV2Router01(router).addLiquidityETH{value: msg.value}(token, _amount, 1, 1, msg.sender, block.timestamp);
    }
    // buyToken()：用户可调用该函数实现购买 MyToken
    function buyToken() public payable {
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = token;
        IUniswapV2Router01(router).swapExactETHForTokens{value:msg.value}(0, path, msg.sender, block.timestamp);
    }
    // 完成代币兑换后，直接质押 MasterChef
    //    * withdraw():从 MasterChef 提取 Token 方法
}

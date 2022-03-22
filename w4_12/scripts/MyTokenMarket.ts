import { ethers } from "hardhat"
// 添加流动性 需要先授权
export const MyTokenMarket = async ( token:string, router:string,weth:string) => {
    const MyTokenMarket = await ethers.getContractFactory("MyTokenMarket");
    const market = await MyTokenMarket.deploy(token, router, weth);
    await market.deployed()

    const [signer] = await ethers.getSigners();
    const mt = await ethers.getContractAt("MyToken1",token,signer)
    //  授权
    await mt.approve(market.address,ethers.constants.MaxUint256)
    // 再 添加流动心性
    const add = await market.AddLiquidity(ethers.utils.parseEther('1'),{value: ethers.utils.parseEther('0.01')});
    console.log(add);
        
    // //  交易
    // const buy = await market.buyToken({value:ethers.utils.parseEther('0.1')})
    // console.log(buy);
    
    
}

// {
//     let jsonRpcProvider
// = new ethers.providers.JsonRpcProvider();
// let [owner, owner2]
// = await ethers.getSigners();
// const UniswapMarketV2 = await new ethers.ContractFactory(marketAbi, marketBytecode, owner);
// const market = await UniswapMarketV2.attach (depolyedAddr.address);
// const AirToken = await new ethers.ContractFactory (token1Abi, token1Bytecode, owner):
// cost token1 = await AirToken.attach(depolyedTokenAddr.address);
// const SushiToken = await new ethers.ContractFactory (sushiAbi, sushiBytecode, owner) ;
// cost sushi = await SushiToken.attach(depolyedSushiAddr.address);
// //给market合约授权
// let amount = ethers.utils.parseUnits("100000".
// 18) :
// let tx = await token1.approve(market.address, amount);
// await tx.wait();
// console.log("tokenA approve successed, amount:
// amount);
// tx
// = await token1.allowance (owner.address, market.address);
// console.log("tokenA allowance balance:
// ethers.utils.formatUnits(tx,18));
// console.log("addLiquidity begin");
// tx = await market.addLiquidity(amount, 0, 0, owner.address, {value:ethers.utils.parseUnits("100", 18)}):
// await tx.wait);
// console.log("addLiquidity successed");
// }
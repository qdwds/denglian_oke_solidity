
import { ethers } from "hardhat";
import { MyTokenMarket } from "./MyTokenMarket";
import { myToken1 } from "./myToken1";
import { myToken2 } from "./myToken2";
import { factory } from "./UniswapV2Factory";
import { router2 } from "./UniswapV2Route2";
async function main() {
  const WETH = await ethers.getContractFactory("WETH9");
  const weth = await WETH.deploy();
  await weth.deployed();
  const wethAddress = weth.address;
  // WETH
  console.log("WETH address:", wethAddress);

  // factory 
  const factoryAddress = await factory();
  console.log("factory address:",factoryAddress);
  
  // router2
  const router2Addrress = await router2(factoryAddress, wethAddress);
  console.log("router2 address:",router2Addrress);
  
  // token1
  const myToken1Address = await myToken1();
  console.log("myToken1 address:", myToken1Address);
  
  // token2
  // const myToken2Address = await myToken2();
  // console.log("myToken2 address:",myToken2Address);

    
 await MyTokenMarket(myToken1Address, router2Addrress, wethAddress);
  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

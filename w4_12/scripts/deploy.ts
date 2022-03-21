
import { ethers } from "hardhat";
import { token } from "./mytoken";
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
  const token1 = await token("A token Coin", "ATC",1000);
  console.log("token1 address:", token1);
  
  // token2
  const token2 = await token("A token Coin", "ATC",1000);
  console.log("token2 address:",token2);

 
  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

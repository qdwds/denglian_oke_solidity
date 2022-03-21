import { ethers } from "hardhat";
export const router2 = async (factory: string, weth: string): Promise<string> => {
    const UniswapV2Router02 = await ethers.getContractFactory("UniswapV2Router02");
    const route2 = await UniswapV2Router02.deploy(factory, weth);
    await route2.deployed();
    return route2.address;
}
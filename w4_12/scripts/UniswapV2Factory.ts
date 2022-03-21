import { ethers } from "hardhat";
export const factory = async (): Promise<string> => {
    const uniswapV2Factory = await ethers.getContractFactory("UniswapV2Factory");
    const userAddress = await uniswapV2Factory.signer.getAddress();
    const factory = await uniswapV2Factory.deploy(userAddress);
    await factory.deployed();
    return factory.address
}
import { ethers } from "hardhat";
export const factory = async (): Promise<string> => {
    const uniswapV2Factory = await ethers.getContractFactory("UniswapV2Factory");
    const factory = await uniswapV2Factory.deploy("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266");
    await factory.deployed();
    return factory.address
}
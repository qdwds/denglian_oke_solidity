import { ethers } from "hardhat"

export const token = async (name: string, symbol: string, total: number): Promise<string> => {
    const MyToken = await ethers.getContractFactory("MyToken");
    const myToken = await MyToken.deploy(name, symbol, total);
    myToken.deployed();
    return myToken.address;
}
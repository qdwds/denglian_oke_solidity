import { ethers } from "hardhat"

export const myToken1 = async (): Promise<string> => {
    const MyToken1 = await ethers.getContractFactory("MyToken1");
    const myToken1 = await MyToken1.deploy();
    myToken1.deployed();
    
    const signer = await (await ethers.getSigner("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266")).getBalance();
    const balance = await myToken1.balanceOf("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266");
    return myToken1.address;
}
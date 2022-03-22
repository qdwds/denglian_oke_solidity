import { ethers } from "hardhat"

export const myToken2 = async (): Promise<string> => {
    const MyToken2 = await ethers.getContractFactory("MyToken2");
    const myToken2 = await MyToken2.deploy();
    myToken2.deployed();
    return myToken2.address;
}
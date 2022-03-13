
import { artifacts, ethers, network } from "hardhat";
import { writeAbi } from "../utils/save";

//  myToken
export async function myToken():Promise<string>{
    return new Promise(async (resolve, reject ) =>{
        const MyToken = await ethers.getContractFactory("MyToken");
        const my = await MyToken.deploy("my token","MT");
        await my.deployed();
        const my_addr = my.address;

        //  abi
        const artifact = await artifacts.readArtifact("MyToken");
        await writeAbi(artifact, my_addr, "myToken", network.name);
        console.log("MyToken：",my_addr);
        
        resolve(my_addr);
    })

}

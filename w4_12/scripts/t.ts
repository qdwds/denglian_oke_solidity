import { ethers } from "hardhat"

const main = async () => {
    const M = await ethers.getContractFactory("MyTokenMarket");
    const m = await M.deploy();
    await m.deployed();

    m.buyToken();
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  
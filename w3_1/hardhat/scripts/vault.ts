
import { artifacts, ethers, network } from "hardhat";
import { writeAbi } from "../utils/save";
import { myToken } from "./myToken";
async function main() {
  //  ERC20
  const myToken_addr = await myToken();

  //  Vault
  const Vault = await ethers.getContractFactory("Vault");
  const va = await Vault.deploy(myToken_addr);
  await va.deployed();
  const va_addr = va.address;

  const depAddr = await va.signer.getAddress();

  console.log("Vault：",va_addr);
  console.log("部署地址：", depAddr);
  
  //  abi
  const artifact = await artifacts.readArtifact("Vault");
  await writeAbi(artifact, va_addr, "vault", network.name);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

import { ethers, artifacts, network} from "hardhat";
import { writeAbi } from "../utils/save";
async function main() {
  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy();

  await nft.deployed();

  const artifact = await artifacts.readArtifact("NFT");
  await writeAbi(artifact, nft.address, "nft", network.name);
  console.log("NFT：",nft.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

import { ethers } from "ethers";
import type { JsonRpcSigner } from "@ethersproject/providers";
import { abi, info } from "../../hardhat/abi/nft.json";
let signer:JsonRpcSigner;
let nft;
const init = async () =>{
    await metamsk();
    NFTContract();
}
const metamsk =async() => {
    const privider = new ethers.providers.Web3Provider(window.ethereum)
    await privider.send("eth_requestAccounts",[]);
    signer = privider.getSigner();
    
}
const NFTContract = () => {
    nft = new ethers.Contract(info.address,abi,signer);
    console.log(nft);
    
}

window.addNFT = async () => {
    const OAddr = document.getElementById("addr");
    const OData = document.getElementById("data");
    if(OAddr && OData){
        const result = await nft.addNFT(OAddr.value, OData.value);
        await result.wait();
    }
}


window.tokenURI = async () => {
    const OID = document.getElementById("data_id");
    if(OID){
        const result = await nft.tokenURI(1);
        console.log(result);
        document.getElementById("tokenuri").innerHTML = result;
    }
    
}

init();
import { Contract, ethers } from "ethers"
import { info as vault_info, abi as vault_abi } from "../../hardhat/abi/vault.json";
import { info as myToken_info, abi as myToken_abi } from "../../hardhat/abi/myToken.json";
import type { JsonRpcSigner } from "@ethersproject/providers";
export let signer: JsonRpcSigner;

let vault: Contract;
let myToken: Contract;
const dec:number = 18;

//  链接MetaMask
export const metaMask = async () => {
    const privider = new ethers.providers.Web3Provider(window.ethereum);
    console.log(privider);
    
    //  当前链接的用户
    await privider.send("eth_requestAccounts", []);
    //  获取网络信息
    await privider.getNetwork();
    signer = privider.getSigner();

}

export const vaultContract = async () => {
    vault = new ethers.Contract(vault_info.address, vault_abi, signer);
    console.log(vault);
    await vaultInfo();
}

export const myTokenContract = async () => {
    myToken = new ethers.Contract(myToken_info.address, myToken_abi, signer);
    // console.log(myToken);
    await myTokenInfo();
}

const myTokenInfo = async () => {
    document.getElementById("m_token").innerHTML = await myToken.address;
    document.getElementById("m_name").innerHTML = await myToken.name();
    document.getElementById("m_symbol").innerHTML = await myToken.symbol();
    document.getElementById("m_decimals").innerHTML = await myToken.decimals();
    document.getElementById("m_totalSupply").innerHTML = await ethers.utils.formatUnits(await myToken.totalSupply(), dec);
}
//  增发
const incrementTotalSupply = async () => {
    const OValue = document.getElementById("m_val_in");
    const OAddr = document.getElementById("m_addr_in");
    if(OValue && OAddr){
        const total = await myToken.incrementTotalSupply(OAddr.value, OValue.value);
        await total.wait()
        myTokenInfo();
        userInfo();
    }
}
//  销毁
const decrementTotalSupply = async () => {
    const OValue = document.getElementById("m_val_de");
    const OAddr = document.getElementById("m_addr_de");
    if(OValue && OAddr){
        const total = await myToken.decrementTotalSupply(OAddr.value, OValue.value);
        await total.wait();
        myTokenInfo();
        userInfo();
    }
}

//  转账
const transfer = async () => {
    const OTo = document.getElementById("m_to");
    const OVal = document.getElementById("m_tramsfer_val");
    if(OVal && OTo){
        const result = await myToken.transfer(OTo.value, OVal.value);
        await result.wait();
        myTokenInfo();
        userInfo();
    }
}
const allowance = async () => {
    const OF = document.getElementById("m_all_f");
    const OT = document.getElementById("m_all_t");
    if(OF && OT){
        const result = await myToken.allowance(OF?.value, OT?.value);
        console.log(result);
        console.log(ethers.utils.formatUnits(result.toString(),10));
        
        document.getElementById("m_all_v").innerHTML = ethers.utils.formatUnits(result.toString(), 18);
    }
}
//  userinfo
export const userInfo = async () =>{
    const user_addr = await signer.getAddress();
    document.getElementById("m_user").innerHTML = user_addr;
    document.getElementById("m_balan").innerHTML = await myToken.balanceOf(user_addr);
}

const vaultInfo = async () => {
    document.getElementById("v_addr").innerHTML = await vault.address;
    document.getElementById("v_total").innerHTML = await vault.totalSupply();
}

//  获取用户余额
const vaultAll = async () => {
    const OAD = document.getElementById("v_all_addr");
    if(OAD){
        const result = await vault.vaultAll(OAD.value);
        console.log(ethers.utils.formatUnits(result.toString(), dec));
        document.getElementById("v_all_val").innerHTML = ethers.utils.formatUnits(result.toString(), dec)
    }
}
//  授权
const approveForm = async () => {
    const OVAppr = document.getElementById("v_appr");
    if(OVAppr){
        const result = await vault.approveForm(OVAppr.value);
        await result.wait();
        allowance();
    }
}
//  存款到Vault 并记录合约 余额
const deposite = async () => {
    const OVAMount = document.getElementById("v_amount");
    if(OVAMount){
        const result = await vault.deposite(OVAMount.value);
        await result.wait();
        console.log("1",result);
        vaultInfo();
        
    }
}
//  提款
const withdraw = async () => {

}
export const abi = {
    incrementTotalSupply,
    decrementTotalSupply,
    transfer,
    allowance,
    vaultAll,
    approveForm,
    deposite,
    withdraw
}
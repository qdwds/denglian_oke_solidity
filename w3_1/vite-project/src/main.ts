import { ethers } from "ethers";
import {
    metaMask,
    myTokenContract,
    vaultContract,
    userInfo,
    abi,
} from "./contract";
console.log(ethers);




for (const k in abi) {
    window[k] = abi[k];
    console.log(k);

}



//  默认获取用户信息

const main = async () => {
    await metaMask()
    await myTokenContract()
    await vaultContract()
    await userInfo();
}
main();

window.ethereum.on("accountsChanged",()=>{
    main();
})
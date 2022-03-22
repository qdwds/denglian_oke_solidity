import fs from "fs";
import type { Artifact } from "hardhat/types";
import { resolve, join } from "path";

interface IData {
    info: any,
    abi: any,
}
//  设置Api到本地文件夹中
export const writeAbi = async (artifacts: Artifact, addr: string, name: string, networtk: string) => {
    const data: IData = {
        info: {},
        abi: {}
    };
    data["info"]["contractName"] = name;
    data["info"]["network"] = networtk;
    data["info"]["address"] = addr;
    data["abi"] = artifacts.abi;
    await createContractFile(name, data);
}

//  创建文件
const createContractFile = async (fileName: string, data: IData) => {
    const depPath = resolve(join(__dirname, "..", "abi"));
    const exist = fs.existsSync(depPath)

    if (!exist) {
        fs.mkdirSync(depPath);
    }
    const fileNamePath = resolve(join(depPath, `${fileName}.json`));
    fs.writeFileSync(`${fileNamePath}`, JSON.stringify(data));
}

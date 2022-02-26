import { expect } from "chai";
import { ethers } from "hardhat";

describe("Greeter", function () {
  it("Test counter defalut !", async function () {
    const Greeter = await ethers.getContractFactory("Greeter");
    const greeter = await Greeter.deploy("Hello, world!");
    await greeter.deployed();
    expect(await greeter.counter()).to.equal("Hello, world!");
  });
});

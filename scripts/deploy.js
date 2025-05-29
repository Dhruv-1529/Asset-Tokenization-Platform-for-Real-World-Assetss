const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  const AssetTokenization = await ethers.getContractFactory("AssetTokenization");
  const contract = await AssetTokenization.deploy();

  await contract.deployed();
  console.log("AssetTokenization deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

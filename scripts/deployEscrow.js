const { ethers } = require("hardhat");

async function main() {
  // Get the account that will deploy the contract
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Get the ContractFactory for "ETHEscrow"
  const GiftETH = await ethers.getContractFactory("GiftETH");

  // Start the deployment.
  // The constructor() doesn't take any arguments, so we pass none.
  const giftETH = await GiftETH.deploy();

  // Wait for the contract to be deployed
  await giftETH.waitForDeployment();

  // Get the deployed contract's address
  const contractAddress = await giftETH.getAddress();

  console.log("giftETH deployed to:", contractAddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

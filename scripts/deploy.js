//scripts/deploy.js
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contract with the account:", deployer.address);

    const Card = await ethers.getContractFactory("Card");
    const card = await Card.deploy(deployer.address);

    await card.waitForDeployment();

    console.log("Card contract deployed to:", card.target);
    // console.log("")
}

main()
   .then(() => process.exit(0))
   .catch((error) => {
       console.error(error);
       process.exit(1);
   });

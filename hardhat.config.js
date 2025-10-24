// hardhat.config.js

require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config(); // <-- 1. Loads your .env file

// --- 2. Load your environment variables ---
const BASE_SEPOLIA_RPC_URL = process.env.BASE_SEPOLIA_RPC_URL || "";
const PRIVATE_KEY = process.env.PRIVATE_KEY || "";
const BASESCAN_API_KEY = process.env.BASESCAN_API_KEY || "";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.27", // Make sure this matches your contracts
  
  // --- 3. Configure the network ---
  networks: {
    baseSepolia: {
      url: BASE_SEPOLIA_RPC_URL,  // <-- Uses your .env variable
      accounts: [PRIVATE_KEY],      // <-- Uses your .env variable
    },
  },

  // --- 4. Configure Etherscan/Basescan verification ---
  etherscan: {
    apiKey: {
      baseSepolia: BASESCAN_API_KEY, // <-- Uses your .env variable
    },
    customChains: [ // This is required for Base Sepolia
      {
        network: "baseSepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org"
        }
      }
    ]
  },
};
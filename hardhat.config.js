require("@nomiclabs/hardhat-waffle");
require("@float-capital/solidity-coverage");
require('dotenv').config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();
//
//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });

let {  PrivateKey} = process.env;

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 // * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  defaultNetwork: "hardhat",
  solidity: {
    version: "0.8.11",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545/",
      accounts: [PrivateKey],
      timeout:200000000,
      gasPrice: 5100000000,
      gas: 5000000
    },
    hardhat: {
      forking: {
        url: "https://rpc.testnet.fantom.network/",
        throwOnTransactionFailures: true,
        throwOnCallFailures: true
      }
    },
    bsctestnet: {
      gas: 8000000,
      chainId: 97,
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      // gasPrice: 10100000000,
      accounts: [PrivateKey],
      gasMultiplier: 1.2,
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 2000000000
  }
};

require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("hardhat-gas-reporter");
require("solidity-coverage");
require("hardhat-contract-sizer");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-abi-exporter");
require("dotenv").config();

const accounts = [process.env.PRIVATE_KEY];
const ftmScanApiKey = process.env.FTMSCAN_API_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  gasReporter: {
    enabled: true,
    currency: "EUR",
    token: "FTM",
    gasPriceApi: "https://api.ftmscan.com/api?module=proxy&action=eth_gasPrice",
  },
  networks: {
    hardhat: {
      mining: {
        auto: false,
        interval: 5000,
      },
      blockGasLimit: 350000000000,
      gasPrice: "auto",
      gas: "auto",
      gasMultiplier: 4,
      allowUnlimitedContractSize: true,
    },
    testnet: {
      accounts,
      allowUnlimitedContractSize: true,
      chainId: 4002,
      live: false,
      saveDeployments: true,
      gasMultiplier: 2,
      url: "https://rpc.testnet.fantom.network/",
    },
    mainnet: {
      accounts,
      allowUnlimitedContractSize: true,
      chainId: 250,
      live: true,
      saveDeployments: true,
      gasMultiplier: 2,
      // gasPrice: 9000000000000,
      url: "https://rpcapi.fantom.network/",
    },
  },
  etherscan: {
    apiKey: {
      opera: ftmScanApiKey,
      ftmTestnet: ftmScanApiKey,
    },
  },
  solidity: {
    settings: {
      optimizer: {
        enabled: true,
        runs: 13337,
      },
    },
    compilers: [
      {
        version: "0.7.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 13337,
          },
        },
      },
      {
        version: "0.5.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 13337,
          },
        },
      },
      {
        version: "0.5.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 13337,
          },
        },
      },
    ],
  },
  mocha: {
    timeout: 400000,
  },
  abiExporter: {
    path: "./data/abi",
    runOnCompile: false,
    clear: true,
    only: [],
  },
};

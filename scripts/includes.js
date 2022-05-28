const fs = require("fs");
const hre = require("hardhat");
const BigNumber = require("bignumber.js");
require("dotenv").config();

const oneEther = new BigNumber(Math.pow(10, 18));
const oneUsd = new BigNumber(Math.pow(10, 8));
const oneRay = new BigNumber(Math.pow(10, 27));

const IS_TESTNET = hre.network.name !== "mainnet";

const OWNER = process.env.OWNER_ADDRESS;

let DO_VERIFICATION = false;
if (!IS_TESTNET) {
  DO_VERIFICATION = true;
}

let DB_FILE_NAME;
if (!IS_TESTNET) {
  DB_FILE_NAME = "./deployment-db_mainnet.json";
} else {
  DB_FILE_NAME = "./deployment-db_testnet.json";
}

if (!fs.existsSync(DB_FILE_NAME)) {
  let data = JSON.stringify({}, null, 2);
  fs.writeFileSync(DB_FILE_NAME, data);
}

const rawDb = fs.readFileSync(DB_FILE_NAME);
const DB = JSON.parse(rawDb);
console.log(DB);

const insertContractAddressInDb = (id, address) => {
  if (DB["addresses"] === undefined) {
    DB["addresses"] = {};
  }
  DB["addresses"][id] = address;
  let data = JSON.stringify(DB, null, 2);
  fs.writeFileSync(DB_FILE_NAME, data);
};

const getContractAddressFromDb = (id) => {
  return DB["addresses"][id];
};

const searchContractAddressInDb = (query) => {
  return Object.keys(DB["addresses"])
    .filter((key) => key.includes(query))
    .reduce((obj, key) => {
      return Object.assign(obj, {
        [key]: DB["addresses"][key],
      });
    }, {});
};

const CONTRACT_ID = {
  ArcadeTreasury: "ArcadeTreasury",
  Arcade: "Arcade",
  Distributor: "Distributor",
};

module.exports = {
  insertContractAddressInDb,
  CONTRACT_ID,
  DO_VERIFICATION,
  DB,
  getContractAddressFromDb,
  searchContractAddressInDb,
  OWNER,
};

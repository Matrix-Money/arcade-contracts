const hre = require("hardhat");
const {
  insertContractAddressInDb,
  CONTRACT_ID,
  DO_VERIFICATION,
  DB,
  getContractAddressFromDb,
  searchContractAddressInDb,
  OWNER,
} = require("./includes");

const UTILITY_TOKEN_ADDRESS = "0x04068DA6C83AFCFA0e13ba15A6696662335D5B75"; // usdc
const PRICE = "1000000"; // price in USDC with USDC number of decimals: $1

async function main() {
  const [deployer] = await ethers.getSigners();

  const arcadeContract = await hre.ethers.getContractFactory("Arcade");
  const arcadeInstance = await arcadeContract.deploy(
    deployer.address,
    UTILITY_TOKEN_ADDRESS,
    getContractAddressFromDb(CONTRACT_ID.Distributor),
    getContractAddressFromDb(CONTRACT_ID.ArcadeTreasury),
    PRICE
  );
  await arcadeInstance.deployed();
  if (DO_VERIFICATION) {
    await hre.run("verify:verify", {
      address: arcadeInstance.address,
      constructorArguments: [
        deployer.address,
        UTILITY_TOKEN_ADDRESS,
        getContractAddressFromDb(CONTRACT_ID.Distributor),
        getContractAddressFromDb(CONTRACT_ID.ArcadeTreasury),
        PRICE,
      ],
    });
  }
  insertContractAddressInDb(CONTRACT_ID.Arcade, arcadeInstance.address);
  console.log("Arcade deployed to:", arcadeInstance.address);

  const treasuryContract = await hre.ethers.getContractFactory("ArcadeTreasury");
  const treasuryInstance = treasuryContract.attach(
    getContractAddressFromDb(CONTRACT_ID.ArcadeTreasury)
  );
  await treasuryInstance.addAddressToRegistry(getContractAddressFromDb(CONTRACT_ID.Arcade));
  console.log("Arcade added to ArcadeTreasury registry");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

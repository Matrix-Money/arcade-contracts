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

async function main() {
  const [deployer] = await ethers.getSigners();

  const treasuryContract = await hre.ethers.getContractFactory("ArcadeTreasury");
  const treasuryInstance = await treasuryContract.deploy(deployer.address);
  await treasuryInstance.deployed();
  if (DO_VERIFICATION) {
    await hre.run("verify:verify", {
      address: treasuryInstance.address,
      constructorArguments: [deployer.address],
    });
  }
  insertContractAddressInDb(CONTRACT_ID.ArcadeTreasury, treasuryInstance.address);
  console.log("ArcadeTreasury deployed to:", treasuryInstance.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

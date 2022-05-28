const { expect, assert } = require("chai");
const { ethers } = require("hardhat");

describe("Arcade", function () {
  beforeEach(async () => {
    const signers = await ethers.getSigners();

    owner = signers[0];
    buyer = signers[1];
    buyer2 = signers[2];
    buyer3 = signers[3];
  });

  it("Should add entries to leaderboard", async function () {
    const arcadeContract = await ethers.getContractFactory("Arcade");
    const arcadeInstance = await arcadeContract.deploy(
      owner.address,
      ethers.constants.AddressZero,
      ethers.constants.AddressZero,
      ethers.constants.AddressZero,
      "1000000"
    );
    await arcadeInstance.deployed();

    let leaderboard = [
      { position: 1, user: buyer.address, score: "100" },
      { position: 2, user: buyer2.address, score: "90" },
    ];

    await expect(arcadeInstance.addToLeaderboard(1, leaderboard)).to.emit(
      arcadeInstance,
      "LeaderboardUpdated"
    );

    let contractLeaderboard = await arcadeInstance.getLeaderboard(1);
    assert.equal(contractLeaderboard.length, 2);

    await expect(
      arcadeInstance.addToLeaderboard(1, [{ position: 3, user: buyer3.address, score: "60" }])
    ).to.emit(arcadeInstance, "LeaderboardUpdated");

    contractLeaderboard = await arcadeInstance.getLeaderboard(1);
    assert.equal(contractLeaderboard.length, 3);
  });
});

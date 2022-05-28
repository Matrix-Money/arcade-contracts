// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.3 <0.8.0;
pragma abicoder v2;

interface IArcade {
  struct LeaderboardEntry {
    uint256 position;
    address user;
    uint256 score;
  }

  function deposit(uint256 _amount) external;

  function addToLeaderboard(uint256 _leaderboardId, LeaderboardEntry[] calldata _entries) external;

  function triggerJackpotPayment(address _recipient, uint256 _prizeAmount) external;

  function getLeaderboard(uint256 _leaderboardId) external returns (LeaderboardEntry[] memory);

  function setUtilityTokenAddress(address _utilityTokenAddress) external;

  function setDistributorAddress(address _distributorAddress) external;

  function setTreasuryAddress(address _treasuryAddress) external;

  function setPrice(uint256 _price) external;
}

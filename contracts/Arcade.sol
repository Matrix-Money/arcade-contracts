// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "./interfaces/IArcadeTreasury.sol";
import "./interfaces/IArcade.sol";
import "./interfaces/IDistributorV2.sol";
import "./RegistryAware.sol";

// @dev only
// TODO: remove
import "hardhat/console.sol";

contract Arcade is IArcade, RegistryAware {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;
  using Address for address;

  mapping(uint256 => mapping(uint256 => LeaderboardEntry)) leaderboards;
  mapping(uint256 => uint256) leaderboardCounters;

  address utilityTokenAddress;
  address distributorAddress;
  address treasuryAddress;

  uint256 price;

  event LeaderboardUpdated(uint256 _leaderboardId);
  event Deposited(address _user, uint256 _amount);

  constructor(
    address _ownerAddress,
    address _utilityTokenAddress,
    address _distributorAddress,
    address _treasuryAddress,
    uint256 _price
  ) RegistryAware(_ownerAddress) {
    utilityTokenAddress = _utilityTokenAddress;
    distributorAddress = _distributorAddress;
    treasuryAddress = _treasuryAddress;
    price = _price;
  }

  function setPrice(uint256 _price) external override {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender), "admin");
    price = _price;
  }

  function setTreasuryAddress(address _treasuryAddress) external override {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender), "admin");
    treasuryAddress = _treasuryAddress;
  }

  function setDistributorAddress(address _distributorAddress) external override {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender), "admin");
    distributorAddress = _distributorAddress;
  }

  function setUtilityTokenAddress(address _utilityTokenAddress) external override {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender), "admin");
    utilityTokenAddress = _utilityTokenAddress;
  }

  function deposit(uint256 _amount) external override {
    require(_amount >= price, "amount > 0");
    IERC20(utilityTokenAddress).safeTransferFrom(msg.sender, address(this), _amount);
    uint256 jackpotAmount = _amount.mul(25).div(100);
    uint256 buybackBurnAmount = _amount.sub(jackpotAmount);
    IERC20(utilityTokenAddress).safeTransfer(treasuryAddress, jackpotAmount);
    IERC20(utilityTokenAddress).safeTransfer(distributorAddress, buybackBurnAmount);
    emit Deposited(msg.sender, _amount);
  }

  function addToLeaderboard(uint256 _leaderboardId, LeaderboardEntry[] calldata _entries)
    external
    override
  {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender), "admin");
    uint256 currentLeaderboardCounter = leaderboardCounters[_leaderboardId];
    for (uint256 i = 0; i < _entries.length; i++) {
      if (leaderboards[_leaderboardId][_entries[i].position].user == address(0)) {
        leaderboardCounters[_leaderboardId]++;
      }
      currentLeaderboardCounter = leaderboardCounters[_leaderboardId] - 1;
      leaderboards[_leaderboardId][currentLeaderboardCounter].position = _entries[i].position;
      leaderboards[_leaderboardId][currentLeaderboardCounter].user = _entries[i].user;
      leaderboards[_leaderboardId][currentLeaderboardCounter].score = _entries[i].score;
    }
    emit LeaderboardUpdated(_leaderboardId);
  }

  function triggerJackpotPayment(address _recipient, uint256 _prizeAmount) external override {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender), "admin");
    IArcadeTreasury(treasuryAddress).requestTransfer(
      utilityTokenAddress,
      _recipient,
      _prizeAmount,
      address(0),
      0
    );
  }

  function getLeaderboard(uint256 _leaderboardId)
    external
    view
    override
    returns (LeaderboardEntry[] memory)
  {
    LeaderboardEntry[] memory ret = new LeaderboardEntry[](leaderboardCounters[_leaderboardId]);
    for (uint256 i = 0; i < leaderboardCounters[_leaderboardId]; i++) {
      ret[i] = leaderboards[_leaderboardId][i];
    }
    return ret;
  }
}

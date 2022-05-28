// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.7.6;

import "./interfaces/IArcadeTreasury.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

import "./RegistryAware.sol";

// @dev only
// TODO: remove
// import "hardhat/console.sol";

/**
 * @dev Treasury contract only for ERC20 tokens
 */
contract ArcadeTreasury is IArcadeTreasury, RegistryAware {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;
  using Address for address;

  /**
   * @dev Emitted after a transfer bas been completed
   */
  event TransferCompleted(
    address _token,
    address _address1,
    uint256 _amount1,
    address _ddress2,
    uint256 _amount2
  );

  /**
   * @dev Emitted after a deposit bas been completed
   */
  event DepositCompleted(address _token, uint256 _amount);

  constructor(address _ownerAddress) RegistryAware(_ownerAddress) {}

  function deposit(address _token, uint256 _amount) external override {
    IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
    emit DepositCompleted(_token, _amount);
  }

  function requestTransfer(
    address _token,
    address _address1,
    uint256 _amount1,
    address _address2,
    uint256 _amount2
  ) external override onlyIfRegistered {
    _transfer(_token, _address1, _amount1, _address2, _amount2);
  }

  function withdrawToken(address _token, uint256 _amount) external {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender), "e01");
    _transfer(_token, msg.sender, _amount, address(0), 0);
  }

  function _transfer(
    address _token,
    address _address1,
    uint256 _amount1,
    address _address2,
    uint256 _amount2
  ) internal {
    require(IERC20(_token).balanceOf(address(this)) >= _amount1 + _amount2, "e29");
    if (_amount1 > 0) {
      IERC20(_token).safeTransfer(_address1, _amount1);
    }
    if (_amount2 > 0) {
      IERC20(_token).safeTransfer(_address2, _amount2);
    }
    emit TransferCompleted(_token, _address1, _amount1, _address2, _amount2);
  }
}

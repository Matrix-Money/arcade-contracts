// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.7.6;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// @dev only
// TODO: remove
// import "hardhat/console.sol";

/**
 * @dev Abstract contract for use in raffle aware contracts
 */
abstract contract RegistryAware is AccessControl {
  using SafeMath for uint256;
  using Address for address;

  mapping(address => uint256) internal registry;

  /**
   * @dev Emitted when a new raffle is added to registry
   */
  event NewRegistration(address addressToRegister);

  constructor(address _ownerAddress) {
    _setupRole(AccessControl.DEFAULT_ADMIN_ROLE, _ownerAddress);
  }

  function addAddressToRegistry(address _addressToRegister) external {
    require(hasRole(AccessControl.DEFAULT_ADMIN_ROLE, msg.sender));
    registry[_addressToRegister] = 1;
    emit NewRegistration(_addressToRegister);
  }

  function isAddressRegistered(address _address) external view returns (bool) {
    return registry[_address] == 1;
  }

  /**
   * @notice Reverts if caller not registered.
   */
  modifier onlyIfRegistered() {
    require(msg.sender != address(0x0), "e100");
    require(registry[msg.sender] == 1);
    _;
  }
}

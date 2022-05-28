// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.5.3 <0.8.0;
pragma abicoder v2;

interface IArcadeTreasury {
    function requestTransfer(
        address _token,
        address _address1,
        uint256 _amount1,
        address _address2,
        uint256 _amount2
    ) external;

    function deposit(address _token, uint256 _amount) external;
}

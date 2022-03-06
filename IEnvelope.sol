// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

interface IEnvelope {
    function locked(address _asset,uint256 _assetId) external view returns(bool);
    function ownerOfAsset(uint256 _assetId) external view returns(address);
    }

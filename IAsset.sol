// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

interface IAsset {
    function checkMint(address _owner,uint256 _quantity) external returns(uint256);
    function locked(uint256 _assetId) external view returns(bool);
    function ownerOfAsset(uint256 _assetId) external view returns(address);
    }

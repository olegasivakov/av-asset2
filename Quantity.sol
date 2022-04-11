// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './TokenStorage.sol';
import './Math.sol';

contract Quantity is TokenStorage {

    function quantityIsGood(uint256 _quantity,uint256 _minted,uint256 _mintedOnPresale)
    internal view
    returns(bool)
    {
        return
            (
                _contractData.mintStatus == MintStatus.PRESALE &&
                _mintSettings.mintOnPresale >= _quantity + _minted
            ) || (
                _contractData.mintStatus == MintStatus.SALE &&
                _mintSettings.maxMintPerUser >= _quantity + _minted - _mintedOnPresale &&
                _mintSettings.minMintPerUser <= _quantity
            )
            ;
    }

    function supplyIsGood()
    internal view
    returns(bool)
    {
        return
            _contractData.isEnvelope || (
                _contractData.isEnvelope == false &&
                _mintSettings.maxTokenSupply > _currentIndex
            )
            ;
    }

}
// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './TokenStorage.sol';
import './Math.sol';

contract Quantity is TokenStorage {

    function quantityIsGood(uint256 _quantity,uint256 _minted)
    internal view
    returns(bool)
    {
        return
            _mintSettings.maxMintPerUser >= _quantity + _minted &&
            _mintSettings.minMintPerUser <= _quantity
            ;
    }

    function supplyIsGood()
    internal view
    returns(bool)
    {
        return
            _mintSettings.maxTokenSupply > _currentIndex
            ;
    }

}
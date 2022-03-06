// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './TokenStorage.sol';
import './Math.sol';

contract Payment is TokenStorage {

    function lackOfMoney(uint _quantity)
    internal
    returns(bool)
    {
        return msg.value < Math.mul(_contractData.mintStatus == MintStatus.PRESALE ?
        _mintSettings.priceOnPresale : _mintSettings.priceOnSale
        ,_quantity);
    }

    function lackOfMoneyForConcat()
    internal
    returns(bool)
    {
        return
            _mintSettings.envelopeConcatPrice != 0 &&
            _mintSettings.envelopeConcatPrice > msg.value
            ;
    }

    function lackOfMoneyForSplit()
    internal
    returns(bool)
    {
        return
            _mintSettings.envelopeSplitPrice != 0 &&
            _mintSettings.envelopeSplitPrice > msg.value
            ;
    }

}
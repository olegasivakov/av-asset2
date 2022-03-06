// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './ERC721AEnvelope.sol';

abstract contract Master is ERC721AEnvelope {

    constructor() {
        _root = _msgSender();
        _contractData.isRevealed = false;
        _contractData.mintStatus = MintStatus.NONE;
        _mintSettings.maxMintPerUser = 5;
        _mintSettings.minMintPerUser = 1;
        _mintSettings.maxTokenSupply = 10000;
        _mintSettings.priceOnPresale = 0;
        _mintSettings.priceOnSale = 0;
        _mintSettings.envelopeConcatPrice = 0;
        _mintSettings.envelopeSplitPrice = 0;
    }

    function exists(uint256 tokenId)
    external view
    returns(bool)
    {
        return _exists(tokenId);
    }

    function getOwnershipAt(uint256 index)
    external view
    returns(TokenOwnership memory)
    {
        return _ownerships[index];
    }

    function setRoot(address _owner)
    external
    {
        RootOnly();
        
        _root = _owner;
    }

    function getRoot()
    external view
    returns(address)
    {
        return _root;
    }

    function updateContract(
        uint256 _pricePresale,
        uint256 _priceSale,
        uint8 _minMint,
        uint8 _maxMint,
        uint64 _maxSupply
        )
    external
    {
        RootOnly();

        _mintSettings.priceOnPresale = _pricePresale;
        _mintSettings.priceOnSale = _priceSale;
        _mintSettings.maxMintPerUser = _maxMint;
        _mintSettings.minMintPerUser = _minMint;
        _mintSettings.maxTokenSupply = _maxSupply;
    }

    function updateBaseURL(string calldata _url)
    external
    {
        RootOnly();

        _contractData.baseURL = _url;
    }

}
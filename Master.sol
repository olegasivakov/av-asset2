// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './ERC721AEnvelope.sol';

abstract contract Master is ERC721AEnvelope {

    constructor() {
        _root = _msgSender();
        _contractData.isRevealed = false;
        _contractData.mintStatus = MintStatus.NONE;
        _contractData.mintStatusAuto = true;
        _mintSettings.mintOnPresale = 1; // number of tokens on presale
        _mintSettings.maxMintPerUser = 2; // max tokens on sale
        _mintSettings.minMintPerUser = 1; // min tokens on sale
        _mintSettings.maxTokenSupply = 5000;
        _mintSettings.priceOnPresale = 37500000000000000; // in wei, may be changed later
        _mintSettings.priceOnSale = 47500000000000000; // in wei, may be changed later
        _mintSettings.envelopeConcatPrice = 0; // in wei, may be changed later
        _mintSettings.envelopeSplitPrice = 0; // in wei, may be changed later
        _mintSettings.mintStatusPreale = 1649683800; //  Monday, April 11, 2022 2:00:00 PM GMT
        _mintSettings.mintStatusSale = 1649728800; //  Tuesday, April 12, 2022 2:00:00 AM GMT
        _mintSettings.mintStatusFinished = 0; //does not specified
    }

    function exists(uint256 tokenId)
    external view
    returns(bool)
    {
        return _exists(tokenId);
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

    function CheckMintStatus()
    internal
    {
        if(!_contractData.mintStatusAuto)
            return;
        
        uint256 mps = _mintSettings.mintStatusPreale - 86400;
        uint256 ms = _mintSettings.mintStatusSale;
        uint256 mf = _mintSettings.mintStatusFinished;
        if (mps <= block.timestamp && block.timestamp < ms) {
            _contractData.mintStatus = MintStatus.PRESALE;
        } else if (ms <= block.timestamp && (block.timestamp < mf || 0 == mf)) {
            _contractData.mintStatus = MintStatus.SALE;
        } else {
            _contractData.mintStatus = MintStatus.NONE;
        }
    }

    function toggleMintStatus(bool _mode)
    external
    {
        RootOnly();

        _contractData.mintStatusAuto = _mode;
    }

    function setMintingIsOnPresale()
    external
    {
        RootOnly();

        _contractData.mintStatus = MintStatus.PRESALE;
    }
    
    function setMintingIsOnSale()
    external
    {
        RootOnly();

        _contractData.mintStatus = MintStatus.SALE;
    }
     
    function stopMinting()
    external
    {
        RootOnly();

        _contractData.mintStatus = MintStatus.NONE;
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

    function setRevealed(string calldata _url)
    external
    {
        RootOnly();

        _contractData.isRevealed = true;
        _contractData.baseURL = _url;
    }

    function updateBaseURL(string calldata _url)
    external
    {
        RootOnly();

        _contractData.baseURL = _url;
    }

}

// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './IAsset.sol';
import './IEnvelope.sol';
import './Master.sol';

contract Contract is Master, IAsset {

    constructor(
        string memory name_,
        string memory description_,
        string memory symbol_,
        string memory baseURL_,
        string memory contractURL_
    ) ERC721A(
        name_,
        description_,
        symbol_,
        baseURL_,
        contractURL_
    ) Master() {
        _contractData.isEnvelope = false;
    }

    function addAssetType(address _asset)
    external
    {
        RootOnly();

        _envelopeTypes.envelope = _asset;
    }

    function safeMint(address _owner,uint256 _quantity)
    external
    {
        RootOnly();
        ActiveMint();
        
        if (_root != _owner) {
            _checkMint(_owner,_quantity);
        }
        _safeMint(_owner,_quantity);
    }

    function checkMint(address _owner,uint256 _quantity)
    external view
    override
    returns(uint256)
    {
        _checkMint(_owner,_quantity);
        return _numberMinted(_owner) + _quantity;
    }

    function _checkMint(address _owner,uint256 _quantity)
    private view
    {
        if(!quantityIsGood(_quantity,_numberMinted(_owner)))
            revert OutOfMintBoundaries()
            ;
        if(!supplyIsGood())
            revert OutOfMintBoundaries()
            ;
    }

    function locked(uint256 _assetId)
    external view
    override
    returns(bool)
    {
        return IEnvelope(_envelopeTypes.envelope).locked(address(this),_assetId);
    }

    function ownerOfAsset(uint256 _assetId)
    public view
    override
    returns(address)
    {
        return ownershipOf(_assetId).addr;
    }

    function setRevealed(string calldata _url)
    external
    {
        RootOnly();

        _contractData.isRevealed = true;
        _contractData.baseURL = _url;
    }

    function unlock(uint256 _assetId,address _owner)
    external
    {
        address sender = _msgSender();
        if (
            (_root == sender || _envelopeTypes.envelope == sender) &&
            IEnvelope(_envelopeTypes.envelope).locked(address(this),_assetId)
        ) {
            _transfer(ownerOfAsset(_assetId),_owner,_assetId);
        } else revert AssetLocked();
    }

}

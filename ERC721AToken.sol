// SPDX-License-Identifier: MIT
// Creator: Chiru Labs & OZ

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/utils/Context.sol';

import './ERC721A.sol';
import './Ownership.sol';

/**
 * @title ERC721A Base Token
 * @dev ERC721A Token that can be irreversibly burned (destroyed).
 */
abstract contract ERC721AToken is Context, Ownership, ERC721A {
    using Strings for uint256;

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name()
    external view virtual
    override
    returns(string memory)
    {
        return _contractData.name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol()
    external view virtual
    override
    returns(string memory)
    {
        return _contractData.symbol;
    }

    function baseTokenURI()
    external view
    returns(string memory)
    {
        return _contractData.baseURL;
    }
  
    function contractURI()
    external view
    returns(string memory)
    {
        return _contractData.contractURL;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId)
    external view
    override
    returns(string memory)
    {
        if (!_exists(tokenId))
            revert URIQueryForNonexistentToken();

        if (!_contractData.isRevealed) {
            return _contractData.baseURL;
        } else if (!_contractData.isEnvelope && _assetsEnveloped[address(this)][tokenId]) {
            return Strings.concat(_contractData.baseURL, "/locked.json");
        } else {
            return string(
                abi.encodePacked(
                    _contractData.baseURL,
                    Strings.toString(tokenId),
                    ".json"
                ));
        }
    }

    function decimals()
    external pure
    returns(uint8)
    {
        return 0;
    }

    /**
     * @dev Burns `tokenId`. See {ERC721A-_burn}.
     *
     * Requirements:
     *
     * - The caller must own `tokenId` or be an approved operator.
     */
    function burn(uint256 tokenId)
    internal
    {
        if(!_contractData.isEnvelope)
            if(IEnvelope(_envelopeTypes.envelope).locked(address(this),tokenId))
                revert AssetLocked();
                
        TokenOwnership memory prevOwnership = ownershipOf(tokenId);

        bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
            isApprovedForAll(prevOwnership.addr, _msgSender()) ||
            getApproved(tokenId) == _msgSender());

        if (!isApprovedOrOwner)
            revert TransferCallerNotOwnerNorApproved();

        _burn(tokenId);
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

}
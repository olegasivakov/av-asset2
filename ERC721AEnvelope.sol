// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './IAsset.sol';
import './Math.sol';
import './Array.sol';
import './ERC721AToken.sol';

//import "hardhat/console.sol";

abstract contract ERC721AEnvelope is Array, Context, ERC721AToken {
    using Math for uint256;

    function _mintSetOfAssets(address _owner,uint _quantity)
    internal
    {
        unchecked {
            for(uint i = 0; i < _envelopeTypes.types.length; i++) {
                (bool success,bytes memory res) = _envelopeTypes.types[i].call(
                    abi.encodeWithSignature("safeMint(address,uint256)",
                        _owner,
                        _quantity
                        )
                );
                if(!success)
                    revert Err();
            }
        }
    }

    function _envelopeAssets(uint256 _envelopeId)
    internal view
    returns(address[] memory,uint256[] memory)
    {
        unchecked {
            uint len = 0;
            for (uint i = 0; i < _envelopeTypes.types.length; i++) {
                len++;
            }
            address[] memory addrs = new address[](len);
            uint256[] memory tokens = new uint256[](len);
            len = 0;
            for (uint i = 0; i < _envelopeTypes.types.length; i++) {
                addrs[len] = _envelopeTypes.types[i];
                tokens[len++] = _assetsEnvelope[_envelopeId][_envelopeTypes.types[i]];
            }
            return (addrs,tokens);
        }
    }

    function _envelopeSplit(address _owner,uint256 _envelopeId)
    internal
    returns(address[] memory,uint256[] memory)
    {
        OwnerOnly(_owner,_envelopeId);

        (address[] memory addrs,uint256[] memory tokens) = _envelopeAssets(_envelopeId);
        _burn(_envelopeId);
        _transferEnvelope(_owner,_envelopeId);
        unchecked {
            for(uint i = 0; i < addrs.length; i++) {
                _unlockEnvelopeAsset(
                        _envelopeId,
                        addrs[i],
                        tokens[i]
                        );
            }
        }
        return (addrs,tokens);
    }

    function _unlockEnvelopeAsset(uint256 _envelopeId,address _asset,uint256 _assetId)
    internal
    {
        if(!_locked(_asset,_assetId))
            revert AssetNotLocked();
        if(_msgSender() != IAsset(_asset).ownerOfAsset(_assetId))
            revert CallerNotOwnerNorApproved();

        delete _assetsEnveloped[_asset][_assetId];
        delete _assetsEnvelope[_envelopeId][_asset];
    }

    function _envelopeCreate(address _owner,address[] calldata _assets,uint256[] calldata _assetIds)
    internal
    returns(uint256)
    {
        if(
            _assets.length == 0 &&
            _assets.length != _assetIds.length
        ) revert Err();

        uint256 envelopeId = _currentIndex;
        _safeMint(_owner,1);
        unchecked {
            _assetsEnvelope[envelopeId][_envelopeTypes.envelope] = envelopeId;
            for(uint i = 0; i < _assets.length; i++) {
                if(_locked(_assets[i],_assetIds[i]))
                    revert AssetLocked();
                if(_owner != IAsset(_assets[i]).ownerOfAsset(_assetIds[i]))
                    revert CallerNotOwnerNorApproved();
                _assetsEnvelope[envelopeId][_assets[i]] = _assetIds[i];
                _assetsEnveloped[_assets[i]][_assetIds[i]] = true;
            }
        }
        return envelopeId;
    }

    function _locked(address _asset,uint256 _assetId)
    internal view
    returns(bool)
    {
        if (_contractData.isEnvelope)
            return _assetsEnveloped[_asset][_assetId];
        else
            return IAsset(_envelopeTypes.envelope).locked(_assetId);
    }

}

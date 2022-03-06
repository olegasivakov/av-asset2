// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import './Ownership.sol';
import './IWhitelist.sol';

contract AccessControl is Ownership {

    function ActiveMint()
    internal view
    {
        if(MintStatus.NONE == _contractData.mintStatus)
            revert MintShouldBeOpened();
    }

    function ApprovedOnly(address owner)
    internal view
    {
        if (!_operatorApprovals[owner][_msgSender()]) {
            revert CallerNotOwnerNorApproved();
        }
    }

    function OwnerOnly(address owner,uint256 tokenId)
    internal view
    {
        if (owner != ownershipOf(tokenId).addr) {
            revert CallerNotOwnerNorApproved();
        }
    }

    function RootOnly()
    internal view
    {
        address sender = _msgSender();
        if(
            sender != _root &&
            sender != _envelopeTypes.envelope
        ) revert RootAddressError();
    }

    function Whitelisted()
    internal view
    {
        address sender = _msgSender();
        bool flag =
            _root == sender ||
            _addressData[sender].whitelisted == true ||
            _contractData.mintStatus == MintStatus.SALE
        ;
        if(!flag) flag = IWhitelist(Whitelist).check(sender);
        if(!flag)
            revert WhitelistedOnly();
    }


}
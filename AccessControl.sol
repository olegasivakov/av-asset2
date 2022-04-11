// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
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
        if (!_operatorApprovals[owner][_msgSender()])
            revert CallerNotOwnerNorApproved();
    }

    function BotProtection()
    internal view
    {
        if(tx.origin != msg.sender)
            revert Err();
    }

    function OwnerOnly(address owner,uint256 tokenId)
    internal view
    {
        if (owner != ownershipOf(tokenId).addr)
            revert CallerNotOwnerNorApproved();
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

    function Whitelisted(bytes32[] calldata _merkleProof)
    internal view
    {
        address sender = _msgSender();
        bool flag =
            _root == sender ||
            _contractData.mintStatus == MintStatus.SALE
        ;

        /**
         * Set merkle tree root
         */
        if(!flag)
            flag = MerkleProof.verify(_merkleProof, _contractData.wl, keccak256(abi.encodePacked(sender)));

        /**/
        if(!flag)
            revert WhitelistedOnly();
    }

    function setWLRoot(bytes32 _root)
    external
    {
        RootOnly();

        _contractData.wl = _root;
    }

}
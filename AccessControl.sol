// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
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

    function Whitelisted(bytes32[] calldata _merkleProof)
    internal view
    {
        address sender = _msgSender();
        bool flag =
            _root == sender ||
            _addressData[sender].whitelisted == true ||
            _contractData.mintStatus == MintStatus.SALE
        ;

        /**
         * Set merkle tree root
         */
        if(!flag) {
            bytes32 root = 0xd4bc4f2113da59daf4b69a528a42e8046a24d50ae9304af37f5ccd8ee632e88b;
            flag = MerkleProof.verify(_merkleProof, root, keccak256(abi.encodePacked(sender)));
        }

        /**
         * Add as many whitelists as you need
         */
        //if(!flag) flag = IWhitelist(0x2622bBEc5940849997cF50eA644C86ff57E4c94b).check(sender);

        /**/
        if(!flag)
            revert WhitelistedOnly();
    }


}
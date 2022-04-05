// SPDX-License-Identifier: MIT
// Creator: OZ using Chiru Labs

pragma solidity ^0.8.4;

import '@openzeppelin/contracts/utils/Context.sol';

import './Errors.sol';
import './IEnvelope.sol';
import './TokenStorage.sol';

contract Ownership is Context, TokenStorage {

    /**
     * Gas spent here starts off proportional to the maximum mint batch size.
     * It gradually moves to O(1) as tokens get transferred around in the collection over time.
     */
    function ownershipOf(uint256 tokenId)
    internal view
    returns (TokenOwnership memory)
    {
        uint256 curr = tokenId;

        unchecked {
            if (curr < _currentIndex) {
                TokenOwnership memory ownership = _ownerships[curr];
                if (!ownership.burned) {
                    if (ownership.addr != address(0)) {
                        return ownership;
                    }
                    // Invariant: 
                    // There will always be an ownership that has an address and is not burned 
                    // before an ownership that does not have an address and is not burned.
                    // Hence, curr will not underflow.
                    while (true) {
                        curr--;
                        ownership = _ownerships[curr];
                        if (ownership.addr != address(0)) {
                            return ownership;
                        }
                    }
                }
            }
        }
        revert OwnerQueryForNonexistentToken();
    }

    mapping(uint256 => bool) private tokens_;

    function tokensOf(address _owner)
    external
    returns(uint256[] memory)
    {
        unchecked {
            uint n = 0;
            for(uint i=0;i<_currentIndex;i++) {
                tokens_[i] = false;
                TokenOwnership memory ownership = ownershipOf(i);
                if(ownership.addr == _owner) {
                    if (!ownership.burned) {
                        if(_contractData.isEnvelope) {
                            n++;
                            tokens_[i] = true;
                        } else {
                            if(!IEnvelope(_envelopeTypes.envelope).locked(address(this),i)) {
                                n++;
                                tokens_[i] = true;
                            }
                        }
                    }
                }
            }
            uint256[] memory tokens = new uint256[](n);
            n = 0;
            for(uint i=0;i<_currentIndex;i++)
                if(tokens_[i])
                    tokens[n++] = i;
            return tokens;
        }
    }

}
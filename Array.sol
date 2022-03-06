// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

contract Array{

    function remove(uint256[] memory arr, uint256 e)
    internal pure
    {
        unchecked {
            uint idx = 0;
            for(uint i = 0; i < arr.length; i++) {
                if(arr[i] == e) {
                    idx = i;
                }
            }
            for (uint i = idx; i < arr.length-1; i++){
                arr[i] = arr[i+1];        
            }
            delete arr[arr.length - 1];
        }
    }
    
}
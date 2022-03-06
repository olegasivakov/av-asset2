// SPDX-License-Identifier: MIT
// Creator: OZ

pragma solidity ^0.8.4;

interface IWhitelist {
    function check(address addr) external view returns(bool);
}

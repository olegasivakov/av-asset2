// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * Libraries
 * Used https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol for Strings
 */

library Strings{

    bytes16 private constant _HEXSYMBOLS = "0123456789abcdef";

    function toString(address account) public pure returns(string memory) {
        return toString(abi.encodePacked(account));
    }

    function toString(bytes32 value) public pure returns(string memory) {
        return toString(abi.encodePacked(value));
    }

    function toString(bytes memory data) public pure returns(string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(2 + data.length * 2);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < data.length; i++) {
            str[2+i*2] = alphabet[uint(uint8(data[i] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(data[i] & 0x0f))];
        }
        return string(str);
    }

    function toString(uint256 value) internal pure returns(string memory)
    {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (0 == value) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (0 != temp) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (0 != value) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function toHexString(uint256 value) internal pure returns(string memory)
    {
        if (0 == value) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (0 != temp) {
            length++;
            temp >>= 8;
        }
        return toHexString(value,length);
    }

    function toHexString(uint256 value,uint256 length) internal pure returns(string memory)
    {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEXSYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0);
        return string(buffer);
    }
    
    function concat(string memory self, string memory other) internal pure returns(string memory)
    {
        return string(
        abi.encodePacked(
            self,
            other
        ));
    }
    
}

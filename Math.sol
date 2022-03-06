// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

library Math{

    function max(uint256 a,uint256 b) internal pure returns(uint256)
    {
        return a >= b ? a : b;
    }

    function min(uint256 a,uint256 b) internal pure returns(uint256)
    {
        return a < b ? a : b;
    }

    function average(uint256 a,uint256 b) internal pure returns(uint256)
    {
        return (a & b) + (a ^ b) / 2;
    }

    function ceilDiv(uint256 a,uint256 b) internal pure returns(uint256)
    {
        return a / b + (a % b == 0 ? 0 : 1);
    }

    function mul(uint256 a,uint256 b) internal pure returns(uint256 c)
    {
        if (0 == a) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a,uint256 b) internal pure returns(uint256)
    {
        assert(0 != b);
        return a / b;
    }

    function sub(uint256 a,uint256 b) internal pure returns(uint256)
    {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a,uint256 b) internal pure returns(uint256 c)
    {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

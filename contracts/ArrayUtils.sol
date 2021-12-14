// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayUtils {
    function sum(uint256[] memory xs) internal pure returns (uint256) {
        uint256 c = 0;
        for (uint256 i = 0; i < xs.length; i++) {
            c += xs[i];
        }
        return c;
    }

    function containsString(string[] memory strings, string memory s)
        internal
        pure
        returns (bool)
    {
        bytes32 ks = keccak256(abi.encodePacked(s));
        for (uint256 i = 0; i < strings.length; i++) {
            if (keccak256(abi.encodePacked(strings[i])) == ks) return true;
        }
        return false;
    }

    function containsUint(uint256[] memory xs, uint256 u)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < xs.length; i++) {
            if (xs[i] == u) return true;
        }
        return false;
    }

    function appendIfNew(uint256[] memory xs, uint256 x)
        internal
        pure
        returns (uint256[] memory)
    {
        if (containsUint(xs, x)) {
            return xs;
        }
        uint256[] memory copy = new uint256[](xs.length + 1);
        copy[xs.length] = x;
        for (uint256 i = 0; i < xs.length; i++) copy[i] = xs[i];
        return copy;
    }

    function copyUints(uint256[] memory xs)
        internal
        pure
        returns (uint256[] memory copy)
    {
        copy = new uint256[](xs.length);
        for (uint256 i = 0; i < xs.length; i++) copy[i] = xs[i];
    }
}

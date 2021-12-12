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

    function containsUint(uint256[] memory strings, uint256 u)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < strings.length; i++) {
            if (strings[i] == u) return true;
        }
        return false;
    }
}

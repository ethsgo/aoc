// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringUtils {
    /// Find the index of the given ASCII character.
    ///
    /// Return -1 if not found.
    function indexOf(string memory s, uint8 c) internal pure returns (int256) {
        bytes memory b = bytes(s);
        bytes1 cb = bytes1(c);
        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] == cb) return int256(i);
        }
        return -1;
    }
}

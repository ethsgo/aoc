// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StringUtils {
    /// Find the index of the given ASCII character.
    ///
    /// Return -1 if not found.
    function indexOf(string memory s, bytes1 c) internal pure returns (int256) {
        bytes memory b = bytes(s);
        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] == c) return int256(i);
        }
        return -1;
    }

    /// Return a string representation of the given uint.
    ///
    /// Useful for combining arrays when console logging.
    function uintString(uint256 x) internal pure returns (string memory) {
        if (x == 0) return "0";
        return string(_uintString(x));
    }

    function _uintString(uint256 x) private pure returns (bytes memory) {
        if (x == 0) return bytes.concat();
        bytes1 b = bytes1(uint8(bytes1("0")) + (uint8(x % 10)));
        return bytes.concat(_uintString(x / 10), b);
    }

    /// Return a string representation of the given int.
    ///
    /// Useful for combining arrays when console logging.
    function intString(int256 x) internal pure returns (string memory) {
        if (x == 0) return "0";
        if (x < 0) return string(bytes.concat("-", _uintString(uint256(-x))));
        else return string(_uintString(uint256(x)));
    }
}

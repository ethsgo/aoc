// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Parser {
    /// ASCII constants
    ///
    /// 48 - '0'
    /// 57 - '9'
    uint256 private constant ascii0 = 48;
    uint256 private constant ascii9 = 57;

    /// Only storage arrays have a .push function, so we need to keep the
    /// internal array used by the parse methods as a state variable.
    uint256[] private xsStorage;

    /// Convert the given string into an array of integers.
    ///
    /// Any non-digit character acts as a separator.
    function parseInts(string memory s) internal returns (uint256[] memory) {
        // Strings are not indexable.
        bytes memory b = bytes(s);

        // Clear the stored array, emptying it.
        delete xsStorage;
        // Get a local reference to the storage.
        uint256[] storage xs = xsStorage;

        uint256 x;
        bool didSeeDigit = false;
        for (uint256 i = 0; i < b.length; i++) {
            uint8 ascii = uint8(b[i]);
            if (ascii >= ascii0 && ascii <= ascii9) {
                uint256 digit = ascii - ascii0;
                x *= 10;
                x += digit;

                didSeeDigit = true;
            } else {
                if (didSeeDigit) {
                    xs.push() = x;
                }
                x = 0;
                didSeeDigit = false;
            }
        }

        if (didSeeDigit) {
            xs.push() = x;
        }

        return xs;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Parse simple types, like arrays of integers, or string tokens.
contract Parser {
    /// ASCII constants
    ///
    /// 48  - '0'
    /// 57  - '9'
    uint8 internal constant ascii_0 = 48;
    uint8 internal constant ascii_9 = 57;
    /// 97  - 'a'
    /// 122 - 'z'
    uint8 internal constant ascii_a = 97;
    uint8 internal constant ascii_z = 122;
    /// Newline
    /// 10 - '\n'
    /// 32 - ' ' (space)
    uint8 internal constant ascii_nl = 10;
    uint8 internal constant ascii_sp = 32;

    /// Only storage arrays have a .push function, so we need to keep the
    /// internal array used by the parse methods as a state variable.
    uint256[] private xsStorage;
    string[] private tokensStorage;

    /// Convert the given string into an array of uints.
    ///
    /// Any non-digit character acts as a separator.
    function parseUints(string memory s) internal returns (uint256[] memory) {
        return parseUintsSlice(s, 0, bytes(s).length);
    }

    /// Convert the given string slice into an array of integers.
    ///
    /// startIndex and endIndex behave similar to arguments to the Javascript
    /// Array.slice method, i.e, we parse [startIndex, endIndex), the start
    /// index is inclusive but the end index is excluded, we stop before the end
    /// index.
    ///
    /// Any non-digit character acts as a separator.
    function parseUintsSlice(
        string memory s,
        uint256 startIndex,
        uint256 endIndex
    ) internal returns (uint256[] memory) {
        // Strings are not indexable.
        bytes memory b = bytes(s);

        // Clear the stored array, emptying it.
        delete xsStorage;
        // Get a local reference to the storage.
        uint256[] storage xs = xsStorage;

        uint256 x;
        bool didSeeDigit = false;
        for (uint256 i = startIndex; i < endIndex; i++) {
            uint8 ascii = uint8(b[i]);
            if (ascii >= ascii_0 && ascii <= ascii_9) {
                uint256 digit = ascii - ascii_0;
                x *= 10;
                x += digit;

                didSeeDigit = true;
            } else {
                if (didSeeDigit) {
                    xs.push(x);
                }
                x = 0;
                didSeeDigit = false;
            }
        }

        if (didSeeDigit) {
            xs.push(x);
        }

        // The return type has data location memory, so we return a copy
        // (instead of a pointer to our internal storage).
        return xs;
    }

    /// Convert the given string into an array of tokens.
    ///
    /// Space and newline characters act as separators.
    function parseTokens(string memory s) internal returns (string[] memory) {
        // Strings are not indexable.
        bytes memory b = bytes(s);

        // Clear the stored array, emptying it.
        delete tokensStorage;
        // Get a local reference to the storage.
        string[] storage tokens = tokensStorage;

        bytes memory token;

        bool didSeeNonSeparator = false;
        for (uint256 i = 0; i < b.length; i++) {
            uint8 ascii = uint8(b[i]);
            if (ascii == ascii_nl || ascii == ascii_sp) {
                // separator
                if (didSeeNonSeparator) {
                    tokens.push(string(token));
                    delete token;
                }
                didSeeNonSeparator = false;
            } else {
                token = bytes.concat(token, bytes1(ascii));
                didSeeNonSeparator = true;
            }
        }

        if (didSeeNonSeparator) {
            tokens.push(string(token));
        }

        // The return type has data location memory, so we return a copy
        // (instead of a pointer to our internal storage).
        return tokens;
    }

    /// Convert the given string into an unsigned integer.
    ///
    /// Any non-digit character causes reversion.
    function parseUint(string memory s) internal pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 x;
        for (uint256 i = 0; i < b.length; i++) {
            uint8 ascii = uint8(b[i]);
            require(ascii >= ascii_0 && ascii <= ascii_9);
            uint256 digit = ascii - ascii_0;
            x *= 10;
            x += digit;
        }
        return x;
    }

    /// Parse an ascii digit character into a integer.
    function parseDigit(bytes1 digit) internal pure returns (uint256) {
        return uint8(digit) - ascii_0;
    }
}

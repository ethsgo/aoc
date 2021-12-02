// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Parse simple types, like arrays of integers, or string tokens.
contract Parser {
    /// ASCII constants
    ///
    /// 48  - '0'
    /// 57  - '9'
    uint256 internal constant ascii_0 = 48;
    uint256 internal constant ascii_9 = 57;
    /// 97  - 'a'
    /// 122 - 'z'
    uint256 internal constant ascii_a = 97;
    uint256 internal constant ascii_z = 122;

    /// Only storage arrays have a .push function, so we need to keep the
    /// internal array used by the parse methods as a state variable.
    uint256[] private xsStorage;
    string[] private tokensStorage;
    /// Scratch pad for a single token, used when constructing tokensStorage.
    uint8[] private tokenStorage;

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
    /// Any non-lowercase-letter or non-digit character acts as a separator.
    function parseTokens(string memory s) internal returns (string[] memory) {
        // Strings are not indexable.
        bytes memory b = bytes(s);

        // Clear the stored array, emptying it.
        delete tokensStorage;
        // Get a local reference to the storage.
        string[] storage tokens = tokensStorage;

        // We cannot use a local reference to the tokenStorage, Solidity
        // complains that 'Unary operator delete cannot be appliet to type
        // uint8[] storage pointer'. So for clarity, we just don't create an
        // alias and directly use the storage.
        delete tokenStorage;

        bool didSeeNonSeparator = false;
        for (uint256 i = 0; i < b.length; i++) {
            uint8 ascii = uint8(b[i]);
            if (ascii >= ascii_0 && ascii <= ascii_9) {
                // digit
                tokenStorage.push(ascii);
                didSeeNonSeparator = true;
            } else if (ascii >= ascii_a && ascii <= ascii_z) {
                // lowercase letter
                tokenStorage.push(ascii);
                didSeeNonSeparator = true;
            } else {
                // separator
                if (didSeeNonSeparator) {
                    tokens.push(string(abi.encodePacked(tokenStorage)));
                    delete tokenStorage;
                }
                didSeeNonSeparator = false;
            }
        }

        if (didSeeNonSeparator) {
            tokens.push(string(abi.encodePacked(tokenStorage)));
        }

        // The return type has data location memory, so we return a copy
        // (instead of a pointer to our internal storage).
        return tokens;
    }
}

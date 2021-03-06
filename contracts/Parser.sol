// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Parse simple types, like arrays of integers, or string tokens.
contract Parser {
    /// Some pre-typecasted ASCII constants for convenience.
    uint8 internal constant ascii_0 = uint8(bytes1("0"));
    uint8 internal constant ascii_9 = uint8(bytes1("9"));
    uint8 internal constant ascii_A = uint8(bytes1("A"));
    uint8 internal constant ascii_Z = uint8(bytes1("Z"));
    uint8 internal constant ascii_a = uint8(bytes1("a"));
    uint8 internal constant ascii_z = uint8(bytes1("z"));

    /// Only storage arrays have a .push function, so we need to keep the
    /// internal array used by the parse methods as a state variable.
    uint256[] private xsStorage;
    int256[] private xiStorage;
    string[] private tokensStorage;

    /// Convert the given string into an array of uints.
    ///
    /// Any non-digit character acts as a separator.
    function parseUints(string memory s) internal returns (uint256[] memory) {
        return parseUintsSlice(s, 0, bytes(s).length);
    }

    /// Convert the given string slice into an array of uints.
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

    /// Convert the given string into an array of ints.
    ///
    /// Any non-digit character acts as a separator.
    function parseInts(string memory s) internal returns (int256[] memory) {
        return parseIntsSlice(s, 0, bytes(s).length);
    }

    /// Convert the given string slice into an array of integers.
    ///
    /// See: parseUintsSlice for more details.
    function parseIntsSlice(
        string memory s,
        uint256 startIndex,
        uint256 endIndex
    ) internal returns (int256[] memory) {
        // Strings are not indexable.
        bytes memory b = bytes(s);

        // Clear the stored array, emptying it.
        delete xiStorage;
        // Get a local reference to the storage.
        int256[] storage xi = xiStorage;

        uint256 x;
        bool negative = false;
        bool didSeeDigit = false;
        for (uint256 i = startIndex; i < endIndex; i++) {
            uint8 ascii = uint8(b[i]);
            if (ascii == uint8(bytes1("-")) && x == 0) {
                negative = true;
            } else if (ascii >= ascii_0 && ascii <= ascii_9) {
                uint256 digit = ascii - ascii_0;
                x *= 10;
                x += digit;

                didSeeDigit = true;
            } else {
                if (didSeeDigit) {
                    xi.push(negative ? -int256(x) : int256(x));
                }
                x = 0;
                negative = false;
                didSeeDigit = false;
            }
        }

        if (didSeeDigit) {
            xi.push(negative ? -int256(x) : int256(x));
        }

        // The return type has data location memory, so we return a copy
        // (instead of a pointer to our internal storage).
        return xi;
    }

    /// Convert the given string into an array of tokens.
    ///
    /// Space and newline characters act as separators.
    function parseTokens(string memory s) internal returns (string[] memory) {
        return split(s, "\n", " ", false);
    }

    /// Split the given string into an array of tokens using the given
    /// separator. Empty splits are ignored.
    function split(string memory s, bytes1 sep1)
        internal
        returns (string[] memory)
    {
        return split(s, sep1, 0, false);
    }

    /// Split the given string into an array of tokens using the given
    /// separator.
    ///
    /// Retain empty splits if keepEmpty is true.
    function split(
        string memory s,
        bytes1 sep1,
        bool keepEmpty
    ) internal returns (string[] memory) {
        return split(s, sep1, 0, keepEmpty);
    }

    /// Split the given string into an array of tokens using the given
    /// separators.
    ///
    /// Retain empty splits if keepEmpty is true.
    function split(
        string memory s,
        bytes1 sep1,
        bytes1 sep2,
        bool keepEmpty
    ) internal returns (string[] memory) {
        // Strings are not indexable.
        bytes memory b = bytes(s);

        // Clear the stored array, emptying it.
        delete tokensStorage;
        // Get a local reference to the storage.
        string[] storage tokens = tokensStorage;

        bytes memory token;

        bool didSeeNonSeparator = false;
        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] == sep1 || b[i] == sep2) {
                // separator
                if (didSeeNonSeparator) {
                    tokens.push(string(token));
                    delete token;
                } else if (keepEmpty) {
                    tokens.push("");
                }
                didSeeNonSeparator = false;
            } else {
                token = bytes.concat(token, b[i]);
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

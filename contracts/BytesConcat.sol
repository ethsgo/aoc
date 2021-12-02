// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Demonstrate the need to use bytes.contact instead of uint8[].push when
/// constructing strings from ASCII codepoints.
contract BytesConcat {
    function main() external returns (uint256) {
        string[] memory tokens = parseTokens("5");

        uint256 d = uint256(parseUint(tokens[0]));

        return d;
    }

    uint256 internal constant ascii_0 = 48;
    uint256 internal constant ascii_9 = 57;

    string[] private tokensStorage;
    /// Scratch pad for a single token, used when constructing tokensStorage.
    bytes private tokenStorage;
    uint8[] private tokenStorageUint8;

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
        // bytes storage pointer'. So for clarity, we just don't create an
        // alias and directly use the storage.
        delete tokenStorage;
        delete tokenStorageUint8;

        bool didSeeNonSeparator = false;
        for (uint256 i = 0; i < b.length; i++) {
            uint8 ascii = uint8(b[i]);
            if (ascii >= ascii_0 && ascii <= ascii_9) {
                // Need to use bytes.contact instead of creating an array of
                // uint8 to ensure that the encoding is correct (otherwise the
                // string indexing stops working later on down the line).
                tokenStorage = bytes.concat(tokenStorage, bytes1(ascii));
                tokenStorageUint8.push(ascii);
                didSeeNonSeparator = true;
            } else {
                // separator
                if (didSeeNonSeparator) {
                    tokens.push(string(abi.encodePacked(tokenStorage)));
                    // tokens.push(string(abi.encodePacked(tokenStorageUint8)));
                    delete tokenStorage;
                }
                didSeeNonSeparator = false;
            }
        }

        if (didSeeNonSeparator) {
            tokens.push(string(abi.encodePacked(tokenStorage)));
            // tokens.push(string(abi.encodePacked(tokenStorageUint8)));
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
            uint8 ascii = uint8(bytes(s)[i]);
            require(ascii >= ascii_0 && ascii <= ascii_9);
            uint256 digit = ascii - ascii_0;
            x *= 10;
            x += digit;
        }
        return x;
    }
}

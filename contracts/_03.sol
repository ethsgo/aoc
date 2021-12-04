// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _03 is Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory tokens = parseTokens(input);
        if (tokens.length == 0) {
            tokens = parseTokens(
                "00100 11110 10110 10111 10101 01111 00111 11100 "
                "10000 11001 00010 01010"
            );
        }
        // return (bitStringToUint(tokens[0]), 0);
        return (p1(tokens), p2(tokens));
    }

    /// Each string in numbers is the binary representation of a number.
    function p1(string[] memory numbers) private pure returns (uint256) {
        bytes memory bits = parity(numbers);

        return decimal(bits) * decimal(inverted(bits));
    }

    /// Construct a uint from a bit string.
    function bitStringToUint(string memory s) private pure returns (uint256) {
        uint256 result;
        bytes memory bits = bytes(s);
        for (uint256 i = 0; i < bits.length; i++) {
            result <<= 1;
            result += (bits[i] == b0) ? 0 : 1;
        }
        return result;
    }

    uint256[] private parseBitStringsStorage;

    /// Construct an array of uints from an array of bit strings.
    function parseBitStrings(string[] memory strings)
        private
        returns (uint256[] memory)
    {
        delete parseBitStringsStorage;
        for (uint256 i = 0; i < strings.length; i++) {
            parseBitStringsStorage.push(bitStringToUint(strings[i]));
        }
        return parseBitStringsStorage;
    }

    /// Return a byte array where each bytes1 represents a bit indicating if the
    /// corresponding position in tokens had more 1s than 0s.
    function parity(string[] memory tokens)
        private
        pure
        returns (bytes memory)
    {
        uint256 len = bytes(tokens[0]).length;
        bytes memory result = bytes.concat();
        // For each bit position
        for (uint256 j = 0; j < len; j++) {
            // See what pre-dominates in each token
            int256 c = 0;
            for (uint256 i = 0; i < tokens.length; i++) {
                c += (bytes(tokens[i])[j] == b0) ? -1 : int8(1);
            }
            result = bytes.concat(result, bytes1(c > 0 ? uint8(1) : uint8(0)));
        }
        return result;
    }

    /// Return an inverted representation of the given bits (stored as a bytes1 array).
    function inverted(bytes memory bits) private pure returns (bytes memory) {
        bytes memory result = bytes.concat();
        for (uint256 i = 0; i < bits.length; i++) {
            uint8 flipped = uint8(bits[i]) == 1 ? uint8(0) : uint8(1);
            result = bytes.concat(result, bytes1(flipped));
        }
        return result;
    }

    /// Return a decimal representation of the given bits (stored as a bytes1 array).
    function decimal(bytes memory bits) private pure returns (uint256) {
        uint256 n = 0;
        for (uint256 i = 0; i < bits.length; i++) {
            n *= 2;
            n += uint8(bits[i]);
        }
        return n;
    }

    /// Convert a bit string into a bytes1 array, with each bytes1 reflecting if
    /// the corresponding bit in the string was 0 or 1.
    function asBytes1(string memory number)
        private
        pure
        returns (bytes memory)
    {
        bytes memory result = bytes.concat();
        bytes memory numberBytes = bytes(number);
        for (uint256 i = 0; i < numberBytes.length; i++) {
            uint8 bit = numberBytes[i] == b0 ? uint8(0) : uint8(1);
            result = bytes.concat(result, bytes1(bit));
        }
        return result;
    }

    /// Each string in numbers is the binary representation of a number.
    function p2(string[] memory numbers) private returns (uint256) {
        return
            decimal(asBytes1(reduce(numbers, true, 0))) *
            decimal(asBytes1(reduce(numbers, false, 0)));
        // return bytes(result).length;
    }

    /// Return the string that matches the bit criteria (most or least common).
    ///
    /// - Each string in numbers is the binary representation of a number.
    /// - `mostCommon` indicates if we should filter by the most common bit.
    /// - `position` in the bit position where we should consider the bit criteria.
    function reduce(
        string[] memory numbers,
        bool mostCommon,
        uint256 position
    ) private returns (string memory) {
        // Count the number of ones in position.
        int256 oneCount = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            oneCount += (bytes(numbers[i])[position] == b0) ? -1 : int8(1);
        }

        // If we're filtering by mostCommon, then filter those numbers that
        // have the more common byte in the jth position
        bytes1 bit = mostCommon
            ? (oneCount >= 0 ? b1 : b0)
            : (oneCount < 0 ? b1 : b0);

        string[] memory filteredNumbers = filter(numbers, position, bit);
        require(filteredNumbers.length > 0);
        if (filteredNumbers.length == 1) {
            return filteredNumbers[0];
        } else {
            return reduce(filteredNumbers, mostCommon, position + 1);
        }
    }

    // We cannot create memory-dynamic arrays yet in Solidity, so use a storage
    // variable as the scratchpad.
    string[] private filterStorage;

    /// Return those strings that have `bit` in the given `position`.
    function filter(
        string[] memory numbers,
        uint256 position,
        bytes1 bit
    ) private returns (string[] memory) {
        delete filterStorage;
        for (uint256 i = 0; i < numbers.length; i++) {
            if (bytes(numbers[i])[position] == bit) {
                filterStorage.push(numbers[i]);
            }
        }
        return filterStorage;
    }

    // Some useful constants
    bytes1 private constant b0 = bytes1(ascii_0);
    bytes1 private constant b1 = bytes1(ascii_0 + 1);
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "hardhat/console.sol";

contract _03Parser is Parser {
    string internal constant exampleInput =
        "00100 11110 10110 10111 10101 01111 00111 11100 "
        "10000 11001 00010 01010";

    /// Construct an array of uints from an array of bit strings.
    function parseBitStrings(string[] memory strings)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](strings.length);
        for (uint256 i = 0; i < strings.length; i++) {
            result[i] = bitStringToUint(strings[i]);
        }
        return result;
    }

    /// Construct a uint from a bit string.
    function bitStringToUint(string memory s) private pure returns (uint256) {
        uint256 result;
        bytes memory bits = bytes(s);
        for (uint256 i = 0; i < bits.length; i++) {
            result <<= 1;
            result += (bits[i] == bytes1(ascii_0)) ? 0 : 1;
        }
        return result;
    }
}

/// Solution to _03 using bit manipulation.
contract _03Bit is _03Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory tokens = parseTokens(
            bytes(input).length == 0 ? exampleInput : input
        );
        uint256[] memory numbers = parseBitStrings(tokens);
        uint256 bitCount = bytes(tokens[0]).length;

        return (p1(numbers, bitCount), p2(numbers, bitCount));
    }

    function p1(uint256[] memory numbers, uint256 bitCount)
        private
        pure
        returns (uint256)
    {
        uint256 a = fromMostCommon(numbers, bitCount);
        uint256 b = invertBits(a, bitCount);
        return a * b;
    }

    /// Construct a number by using the most common bit in each position.
    ///
    /// For each bit position, set the result bit depending on which of 0 or
    /// 1 occurs more amongst all numbers in that bit position.
    function fromMostCommon(uint256[] memory numbers, uint256 bitCount)
        private
        pure
        returns (uint256)
    {
        uint256 result;
        for (uint256 position = bitCount; position > 0; position--) {
            int256 c = bitSkew(numbers, position - 1);
            result <<= 1;
            require(c != 0);
            if (c > 0) {
                result += 1;
            }
        }
        return result;
    }

    /// Return the skew in bit values in the given `position` amongst the given
    /// numbers. Negative values indicate the number of times bit 0 was more common,
    /// while positive values indicate the same for bit 1.
    function bitSkew(uint256[] memory numbers, uint256 position)
        private
        pure
        returns (int256)
    {
        int256 c = 0;
        for (uint256 j = 0; j < numbers.length; j++) {
            if ((numbers[j] >> position) & 1 == 0) {
                c -= 1;
            } else {
                c += 1;
            }
        }
        return c;
    }

    /// Construct a number by inverting the bits of the given number.
    ///
    /// Consider only the lower bitCount bits.
    function invertBits(uint256 number, uint256 bitCount)
        private
        pure
        returns (uint256)
    {
        uint256 result;
        for (uint256 position = bitCount; position > 0; position--) {
            result <<= 1;
            if ((number >> (position - 1)) & 1 == 0) {
                result += 1;
            }
        }
        return result;
    }

    function p2(uint256[] memory numbers, uint256 bitCount)
        private
        returns (uint256)
    {
        // Starting from the rightmost bit.
        uint256 position = bitCount - 1;
        return
            reduce(numbers, true, position) * reduce(numbers, false, position);
    }

    /// Return the number that matches the bit criteria (most or least common)
    /// starting at the given position.
    ///
    /// If most common is true, then we filter the numbers, only keeping those
    /// that have the majority bit amogst all numbers in that position, until
    /// we're left with only one.
    function reduce(
        uint256[] memory numbers,
        bool mostCommon,
        uint256 position
    ) private returns (uint256) {
        int256 c = bitSkew(numbers, position);

        // If we're filtering by mostCommon, then filter those numbers that
        // have the more common byte in the given position.
        uint256 bit = mostCommon ? (c >= 0 ? 1 : 0) : (c < 0 ? 1 : 0);

        uint256[] memory filteredNumbers = filter(numbers, position, bit);
        require(filteredNumbers.length > 0);
        if (filteredNumbers.length == 1) {
            return filteredNumbers[0];
        } else {
            return reduce(filteredNumbers, mostCommon, position - 1);
        }
    }

    // We cannot create memory-dynamic arrays yet in Solidity, so use a storage
    // variable as the scratchpad.
    uint256[] private filterStorage;

    /// Return those strings that have `bit` in the given `position`.
    function filter(
        uint256[] memory numbers,
        uint256 position,
        uint256 bit
    ) private returns (uint256[] memory) {
        delete filterStorage;
        for (uint256 i = 0; i < numbers.length; i++) {
            if (((numbers[i] >> position) & 1) == bit) {
                filterStorage.push(numbers[i]);
            }
        }
        return filterStorage;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _03 is Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory tokens = parseTokens(input);
        if (tokens.length == 0) {
            tokens = parseTokens(
                "00100 11110 10110 10111 10101 01111 00111 11100"
                "10000 11001 00010 01010"
            );
        }

        return (p1(tokens), p2(tokens));
    }

    /// Each string in numbers is the binary representation of a number.
    function p1(string[] memory numbers) private pure returns (uint256) {
        bytes memory bits = parity(numbers);

        return decimal(bits) * decimal(inverted(bits));
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
                c += (bytes(tokens[i])[j] == bytes1(ascii_0)) ? -1 : int8(1);
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

    /// Each string in numbers is the binary representation of a number.
    function p2(string[] memory numbers) private pure returns (uint256) {
        return 0;
    }

    // We cannot create memory-dynamic arrays yet in Solidity, so use a storage
    // variable as the scratchpad.
    string[] private filterStorage;

    /// Return the string that matches the bit criteria (most or least common).
    ///
    /// Each string in numbers is the binary representation of a number.
    ///
    /// `mostCommon` indicates if we should filter by the most common bit.
    function filter(string[] memory numbers, bool mostCommon)
        private
        pure
        returns (string memory)
    {
        uint256 len = bytes(numbers[0]).length;
        // For each bit,
        for (uint256 j = 0; j < len; j++) {
            // Count the number of ones in that position.
            int256 oneCount = 0;
            for (uint256 i = 0; i < numbers.length; i++) {
                oneCount += (bytes(numbers[i])[j] == bytes1(ascii_0))
                    ? -1
                    : int8(1);
            }
        }
        revert();
    }
}

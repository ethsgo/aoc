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

        bytes memory parity = parityBytes(tokens);

        return (parity.length, uint8(bytes1(parity[0])));
        // return (p1(dxdy), p2(dxdy));
    }

    // Return a byte array where each bytes1 represents a bit indicating if the
    // corresponding position in tokens had more 1s than 0s.
    function parityBytes(string[] memory tokens)
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

    function p1() private pure returns (uint256) {
        return 0;
    }

    function p2() private pure returns (uint256) {
        return 0;
    }
}

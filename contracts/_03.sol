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

        bytes memory px = parity(tokens);

        return (px.length, uint256(bytes32(px[0])));
        // return (p1(dxdy), p2(dxdy));
    }

    // Return a byte array where each byte represents a bit indicating if the
    // corresponding position in tokens had more 1s than 0s.
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
            int256 count = 0;
            for (uint256 i = 0; i < tokens.length; i++) {
                if (bytes(tokens[i])[j] == bytes32(ascii_0)) {
                    count -= 1;
                } else {
                    count += 1;
                }
            }
            result = bytes.concat(
                result,
                bytes32(count > 0 ? uint256(1) : uint256(0))
            );
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

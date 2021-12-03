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

        Bitmap memory parityBitmap = parity(tokens);

        return (parityBitmap.len, parityBitmap.bits);
        // return (p1(dxdy), p2(dxdy));
    }

    struct Bitmap {
        uint256 len;
        uint256 bits;
    }

    // Return a bitmap which has a bit set if the corresponding position in
    // token had more 1s than 0s.
    function parity(string[] memory tokens)
        private
        pure
        returns (Bitmap memory)
    {
        uint256 len = bytes(tokens[0]).length;
        uint256 bits = 0;
        // For each bit position
        for (uint256 j = 0; j < len; j++) {
            for (uint256 i = 0; i < tokens.length; i++) {}
        }
        Bitmap memory result = Bitmap({len: len, bits: bits});
        return result;
    }

    function p1() private pure returns (uint256) {
        return 0;
    }

    function p2() private pure returns (uint256) {
        return 0;
    }
}

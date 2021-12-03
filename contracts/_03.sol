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

    function parity(string[] memory tokens)
        private
        pure
        returns (Bitmap memory)
    {
        // uint256 len;
        Bitmap memory result = Bitmap({len: 0, bits: 0});
        return result;
    }

    function p1() private pure returns (uint256) {
        return 0;
    }

    function p2() private pure returns (uint256) {
        return 0;
    }
}

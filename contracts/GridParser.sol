// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract GridParser is Parser {
    /// Parse a grid of digits into a 2d array
    function parseDigitGrid(string memory s)
        internal
        returns (uint256[][] memory grid)
    {
        string[] memory tokens = parseTokens(s);

        grid = new uint256[][](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            bytes memory b = bytes(tokens[i]);
            grid[i] = new uint256[](b.length);
            for (uint256 j = 0; j < b.length; j++) {
                grid[i][j] = parseDigit(b[j]);
            }
        }
    }
}

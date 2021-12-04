// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _04 is Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory tokens = parseTokens(input);
        if (tokens.length == 0) {
            tokens = parseTokens("");
        }

        return (p1(tokens), p2(tokens));
    }

    function p1(string[] memory tokens) private pure returns (uint256) {
        return 0;
    }

    function p2(string[] memory tokens) private pure returns (uint256) {
        return 0;
    }
}

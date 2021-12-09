// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./ArrayUtils.sol";

contract _09Parser is Parser {
    string private constant exampleInput =
        "2199943210 "
        "3987894921 "
        "9856789892 "
        "8767896789 "
        "9899965678 ";

    function parse(string memory input) internal returns (uint256[][] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);

        uint256[][] memory result = new uint256[][](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            bytes memory b = bytes(tokens[i]);
            result[i] = new uint256[](b.length);
            for (uint256 j = 0; j < b.length; j++) {
                result[i][j] = parseDigit(b[j]);
            }
        }
        return result;
    }
}

contract _09 is _09Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[][] memory heatmap = parse(input);
        return (p1(heatmap), p2(heatmap));
    }

    function p1(uint256[][] memory heatmap) private pure returns (uint256) {
        return heatmap.length;
    }

    function p2(uint256[][] memory) private pure returns (uint256) {
        return 0;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./StringUtils.sol";

contract _04Parser is Parser, StringUtils {
    string internal constant exampleInput =
        "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\
\n\
22 13 17 11  0\n\
 8  2 23  4 24\n\
21  9 14 16  7\n\
 6 10  3 18  5\n\
 1 12 20 15 19\n\
\n\
 3 15  0  2 22\n\
 9 18 13 17  5\n\
19  8  7 25 23\n\
20 11 10 24  4\n\
14 21 16 12  6\n\
\n\
14 21 17 24  4\n\
10 16 15  9 19\n\
18  8 23 26 20\n\
22 11 13  6  5\n\
 2  0 12  3  7";

    function parseBingo(string memory input) internal returns (uint256) {
        int256 firstNewlineIndex = indexOf(input, ascii_nl);
        require(firstNewlineIndex >= 0);
        uint256 drawEndIndex = uint256(firstNewlineIndex);

        uint256[] memory draw = parseUintsSlice(input, 0, drawEndIndex);
        uint256[] memory boardNumbers = parseUintsSlice(
            input,
            drawEndIndex,
            bytes(input).length
        );

        return (boardNumbers.length);
    }
}

contract _04 is _04Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256 bingo = parseBingo(
            bytes(input).length == 0 ? exampleInput : input
        );

        return (bingo, 0);
    }

    function p1(string[] memory tokens) private pure returns (uint256) {
        return 0;
    }

    function p2(string[] memory tokens) private pure returns (uint256) {
        return 0;
    }
}

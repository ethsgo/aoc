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

    struct Bingo {
        uint256[] draw;
        /// Use int instead of uint so that we can mark elements on the board
        /// itself by using -1 (note that negating them doesn't work, because
        /// -0 == 0).
        int256[5][5][] boards;
        /// Store the index of the current move within the game.
        uint256 drawIndex;
        /// Winning board's index
        uint256 winningBoardIndex;
    }

    function parseBingo(string memory input) internal returns (Bingo memory) {
        int256 firstNewlineIndex = indexOf(input, ascii_nl);
        require(firstNewlineIndex >= 0);
        uint256 drawEndIndex = uint256(firstNewlineIndex);

        uint256[] memory draw = parseUintsSlice(input, 0, drawEndIndex);
        uint256[] memory boardNumbers = parseUintsSlice(
            input,
            drawEndIndex,
            bytes(input).length
        );

        int256[5][5][] memory boards = parseBoards(boardNumbers);

        return
            Bingo({
                draw: draw,
                boards: boards,
                drawIndex: 0,
                winningBoardIndex: 0
            });
    }

    function parseBoards(uint256[] memory numbers)
        private
        pure
        returns (int256[5][5][] memory)
    {
        require(numbers.length % 25 == 0, "Expected 5x5 boards");
        uint256 boardCount = numbers.length / 25;
        int256[5][5][] memory boards = new int256[5][5][](boardCount);
        for (uint256 i = 0; i < numbers.length; i++) {
            uint256 b = i / 25;
            uint256 bi = i % 25;
            uint256 y = bi / 5;
            uint256 x = bi % 5;
            boards[b][y][x] = int256(numbers[i]);
        }
        return boards;
    }
}

contract _04 is _04Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        return (p1(parseBingo(s)), p2(parseBingo(s)));
    }

    function play(Bingo memory bingo) private pure {
        for (uint256 i = 0; i < bingo.draw.length; i++) {
            bingo.drawIndex = i;

            int256 call = int256(bingo.draw[i]);

            // Mark the call on the boards.
            for (uint256 b = 0; b < bingo.boards.length; b++) {
                for (uint256 y = 0; y < 5; y++) {
                    for (uint256 x = 0; x < 5; x++) {
                        if (bingo.boards[b][y][x] == call) {
                            bingo.boards[b][y][x] = -1;
                        }
                    }
                }
            }

            // See if anyone won.
            for (uint256 b = 0; b < bingo.boards.length; b++) {
                // Column
                for (uint256 y = 0; y < 5; y++) {
                    bool marked = true;
                    for (uint256 x = 0; x < 5; x++) {
                        if (bingo.boards[b][y][x] >= 0) {
                            marked = false;
                            break;
                        }
                    }
                    if (marked) {
                        bingo.winningBoardIndex = b;
                        return;
                    }
                }

                // Row
                for (uint256 x = 0; x < 5; x++) {
                    bool marked = true;
                    for (uint256 y = 0; y < 5; y++) {
                        if (bingo.boards[b][y][x] >= 0) {
                            marked = false;
                            break;
                        }
                    }
                    if (marked) {
                        bingo.winningBoardIndex = b;
                        return;
                    }
                }
            }
        }
        revert();
    }

    function unmarkedSumOfBoard(int256[5][5] memory board)
        private
        pure
        returns (uint256)
    {
        uint256 sum;
        for (uint256 y = 0; y < 5; y++) {
            for (uint256 x = 0; x < 5; x++) {
                if (board[y][x] >= 0) {
                    sum += uint256(board[y][x]);
                }
            }
        }
        return sum;
    }

    function score(Bingo memory bingo) private pure returns (uint256) {
        uint256 lastDraw = bingo.draw[bingo.drawIndex];
        uint256 unmarkedSum = unmarkedSumOfBoard(
            bingo.boards[bingo.winningBoardIndex]
        );
        return lastDraw * unmarkedSum;
    }

    function p1(Bingo memory bingo) private pure returns (uint256) {
        play(bingo);
        return score(bingo);
    }

    function p2(Bingo memory bingo) private pure returns (uint256) {
        play(bingo);
        return score(bingo);
    }
}

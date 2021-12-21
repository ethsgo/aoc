// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "hardhat/console.sol";

contract _21Parser is Parser {
    string private constant exampleInput =
        "Player 1 starting position: 4\n"
        "Player 2 starting position: 8\n";

    function parse(string memory input)
        internal
        returns (uint256[2] memory pos)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n");

        pos[0] = parseUints(lines[0])[1];
        pos[1] = parseUints(lines[1])[1];
    }
}

contract _21 is _21Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[2] memory pos = parse(input);
        return (
            0, //p1(pos),
            // TODO: p2 is still too slow to run for depth 21
            p2(pos)
        );
    }

    function p1(uint256[2] memory initialPos) private pure returns (uint256) {
        uint256 d = 1;
        uint256[2] memory pos = [initialPos[0], initialPos[1]];
        uint256[2] memory score = [uint256(0), 0];
        uint256 pi = 0;
        uint256 rolls = 0;
        while (true) {
            pos[pi] = advance(pos[pi], d, d + 1, d + 2);
            score[pi] += pos[pi];
            d += 3;
            rolls += 3;
            uint256 ni = pi == 0 ? 1 : 0;
            if (score[pi] >= 1000) return score[ni] * rolls;
            pi = ni;
        }
        revert();
    }

    function advance(
        uint256 i,
        uint256 d1,
        uint256 d2,
        uint256 d3
    ) private pure returns (uint256) {
        uint256 d = d1 + d2 + d3;
        d %= 10;
        i += d;
        return (i > 10) ? i - 10 : i;
    }

    function p2(uint256[2] memory pos) private returns (uint256) {
        uint256 w0 = winCount(pos[0], pos[1], 0, 0, 0);
        // TODO: totalGameCount is still not correct
        // uint256 w1 = totalGameCount - w0;
        // return totalGameCount;//w0 > w1 ? w0 : w1;
        return w0;
    }

    uint256[2**19] private memo;
    uint256[10] private mult = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1];
    uint256 private depth = 5;

    // The straightforward memoization using a mapping is too slow, so we need
    // some contortions to speed it up.
    function winCount(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1,
        uint256 pi
    ) private returns (uint256) {
        uint256 key = (((((((i0 << 4) | i1) << 5) | s0) << 5) | s1) << 1) | pi;
        uint256 v = memo[key];
        if (v > 0) return v - 1;

        if (s0 >= depth) {
            v = 1;
        } else if (s1 >= depth) {
            v = 0;
        } else {
            v = 0;

            if (pi == 0) {
                for (uint256 d = 3; d <= 9; d++) {
                    uint256 i = i0 + d;
                    i = (i > 10) ? i - 10 : i;
                    v += (winCount(i, i1, s0 + i, s1, 1) * mult[d]);
                }
            } else {
                for (uint256 d = 3; d <= 9; d++) {
                    uint256 i = i1 + d;
                    i = (i > 10) ? i - 10 : i;
                    v += (winCount(i0, i, s0, s1 + i, 0) * mult[d]);
                }
            }
        }

        memo[key] = v + 1;
        return v;
    }
}

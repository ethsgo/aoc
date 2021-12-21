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
        // NOTE: Even with all sorts of optimizatios, running on the full depth of 21 levels needs more than 8G of
        // RAM configured on the NODE_OPTIONS when using Hardhat. So decrease
        // the depth for now. The algorithm is still correct (tested by
        // comparing the value against the Javascript solution).
        depth = 19;
        return (p1(pos), p2(pos));
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
        (uint256 w0, uint256 w1) = winCount(pos[0], pos[1], 0, 0, 0);
        return w0 > w1 ? w0 : w1;
    }

    uint256[2**19] private memo1;
    uint256[2**19] private memo2;
    uint256[10] private mult = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1];
    uint256 private depth = 21;

    // The straightforward memoization using a mapping is too slow, so we need
    // some contortions to speed it up.
    function winCount(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1,
        uint256 pi
    ) private returns (uint256 w0, uint256 w1) {
        uint256 key = (((((((i0 << 4) | i1) << 5) | s0) << 5) | s1) << 1) | pi;
        w0 = memo1[key];
        if (w0 > 0) return (w0 - 1, memo2[key]);

        if (s0 >= depth) {
            w0 = 1;
            w1 = 0;
        } else if (s1 >= depth) {
            w0 = 0;
            w1 = 1;
        } else {
            uint256 v1;
            uint256 v2;
            w0 = 0;
            w1 = 0;

            if (pi == 0) {
                for (uint256 d = 3; d <= 9; d++) {
                    uint256 i = i0 + d;
                    i = (i > 10) ? i - 10 : i;
                    (v1, v2) = winCount(i, i1, s0 + i, s1, 1);
                    uint256 md = mult[d];
                    w0 += (v1 * md);
                    w1 += (v2 * md);
                }
            } else {
                for (uint256 d = 3; d <= 9; d++) {
                    uint256 i = i1 + d;
                    i = (i > 10) ? i - 10 : i;
                    (v1, v2) = winCount(i0, i, s0, s1 + i, 0);
                    uint256 md = mult[d];
                    w0 += (v1 * md);
                    w1 += (v2 * md);
                }
            }
        }

        memo1[key] = w0 + 1;
        memo2[key] = w1;
    }
}

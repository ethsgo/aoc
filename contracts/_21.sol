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
        (uint256 w0, uint256 w1) = winCount(pos[0], pos[1], 0, 0);
        return w0 > w1 ? w0 : w1;
    }

    uint256[2**18] private memo1;
    uint256[2**18] private memo2;
    uint256[10] private mult = [0, 0, 0, 1, 3, 6, 7, 6, 3, 1];

    function winCount(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1
    ) private returns (uint256 w0, uint256 w1) {
        uint256 key = (((((i0 << 4) | i1) << 5) | s0) << 5) | s1;
        w0 = memo1[key];
        if (w0 > 0) return (w0 - 1, memo2[key]);

        if (s1 >= 21) {
            w1 = 1;
        } else {
            uint256 v0;
            uint256 v1;

            for (uint256 d = 3; d <= 9; d++) {
                uint256 i = i0 + d;
                i = (i > 10) ? i - 10 : i;
                (v1, v0) = winCount(i1, i, s1, s0 + i);
                w0 += (v0 * mult[d]);
                w1 += (v1 * mult[d]);
            }
        }

        memo1[key] = w0 + 1;
        memo2[key] = w1;
    }
}

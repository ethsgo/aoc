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

    // The straightforward implementation doesn't run with hardhat, so we need to do
    // a bunch of contortions to speed it up.
    function p2(uint256[2] memory pos) private returns (uint256) {
        uint256 w0 = winCount(pos[0], pos[1], 0, 0, 0);
        // TODO: totalGameCount is still not correct
        // uint256 w1 = totalGameCount - w0;
        // return totalGameCount;//w0 > w1 ? w0 : w1;
        return w0;
    }

    // mapping(uint256 => uint256) memo;
    // mapping(uint256 => uint256) memoGameCount;
    // uint256 totalGameCount;
    // uint256[(16 * 16 * 32 * 32 * 2) + 1] private memo;
    uint256[2**19] private memo;

    function mkey(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1,
        uint256 pi
    ) private pure returns (uint256) {
        // Use an arbitrary but unique mapping of the arguments to uints, for
        // use as the key to our memoized function results.
        // return (100 * ((100 * ((100 * ((100 * i0) + i1)) + s0)) + s1)) + pi;
        // return (30 * ((30 * ((11 * ((11 * i0) + i1)) + s0)) + s1)) + pi;
        require(i0 < 16 && i1 < 16);
        require(s0 < 32 && s1 < 32);
        //     return
        // (i0 * (16 * 32 * 32 * 2)) |
        // (i1 * (32 * 32 * 2)) |
        // (s0 * (32 * 2)) |
        // (s1 * (2)) |
        // pi;

        return
            (i0 << (4 + 5 + 5 + 1)) |
            (i1 << (5 + 5 + 1)) |
            (s0 << (5 + 5 + 1)) |
            (s1 << (5 + 1)) |
            pi;
    }

    function winCount(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1,
        uint256 pi
    ) private returns (uint256) {
        uint256 key = mkey(i0, i1, s0, s1, pi);
        // uint256 gameCount = memoGameCount[key];
        // console.log(key);
        uint256 v = memo[key];
        if (v > 0) {
            return v - 1;
        }

        uint256 depth = 5;
        if (s0 >= depth) {
            // gameCount = 1;
            v = 1;
        } else if (s1 >= depth) {
            // gameCount = 1;
            v = 0;
        } else {
            v = 0;

            for (uint256 d1 = 1; d1 <= 3; d1++) {
                for (uint256 d2 = 1; d2 <= 3; d2++) {
                    for (uint256 d3 = 1; d3 <= 3; d3++) {
                        uint256 i = pi == 0 ? i0 : i1;
                        uint256 s = pi == 0 ? s0 : s1;
                        i = advance(i, d1, d2, d3);
                        s += i;

                        // gameCount++;
                        if (pi == 0) {
                            v += winCount(i, i1, s, s1, 1);
                        } else {
                            v += winCount(i0, i, s0, s, 0);
                        }
                    }
                }
            }
        }

        memo[key] = v + 1;
        // memoGameCount[key] = gameCount;
        // totalGameCount += gameCount;

        return v;
    }
}

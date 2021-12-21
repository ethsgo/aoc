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
            0, /*p1(pos)*/
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
        uint256[2] memory w = winCount(pos[0], pos[1], 0, 0, 0);
        return w[0] > w[1] ? w[0] : w[1];
    }

    mapping(uint256 => uint256[2]) memo;

    // ~ 1.5x slower than the hand rolled "hash".
    function mkey2(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1,
        uint256 pi
    ) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(i0, i1, s0, s1, pi));
    }

    function mkey(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1,
        uint256 pi
    ) private pure returns (uint256) {
        // Use an arbitrary but unique mapping of the arguments to uints, for
        // use as the key to our memoized function results.
        return (100 * ((100 * ((100 * ((100 * i0) + i1)) + s0)) + s1)) + pi;
    }

    function winCount(
        uint256 i0,
        uint256 i1,
        uint256 s0,
        uint256 s1,
        uint256 pi
    ) private returns (uint256[2] memory) {
        uint256 key = mkey(i0, i1, s0, s1, pi);
        uint256[2] memory v = memo[key];
        if (v[0] != 0 && v[1] != 0) {
            // console.log('hit', key);
            return v;
        }

        if (s0 >= 8) {
            v = [uint256(1), 0];
        } else if (s1 >= 8) {
            v = [uint256(0), 1];
        } else {
            v = [uint256(0), 0];

            for (uint256 d1 = 1; d1 <= 3; d1++) {
                for (uint256 d2 = 1; d2 <= 3; d2++) {
                    for (uint256 d3 = 1; d3 <= 3; d3++) {
                        uint256 i = pi == 0 ? i0 : i1;
                        uint256 s = pi == 0 ? s0 : s1;
                        i = advance(i, d1, d2, d3);
                        s += i;

                        uint256[2] memory w;
                        if (pi == 0) {
                            w = winCount(i, i1, s, s1, 1);
                        } else {
                            w = winCount(i0, i, s0, s, 0);
                        }

                        v[0] += w[0];
                        v[1] += w[1];
                    }
                }
            }
        }

        memo[key] = v;
        return v;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

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
        uint256[2] memory w = winCount(pos, [uint256(0), 0], 0);
        return w[0] > w[1] ? w[0] : w[1];
    }

    mapping(bytes32 => uint256[2]) memo;

    function mkey(
        uint256[2] memory pos,
        uint256[2] memory score,
        uint256 pi
    ) private pure returns (bytes32) {
        // Use an arbitrary but unique mapping of the arguments to uints, for
        // use as the key to our memoized function results.
        return keccak256(abi.encode(pos, score, pi));
    }

    function winCount(
        uint256[2] memory pos,
        uint256[2] memory score,
        uint256 pi
    ) private returns (uint256[2] memory) {
        bytes32 key = mkey(pos, score, pi);
        uint256[2] memory v = memo[key];
        if (v[0] != 0 && v[1] != 0) return v;

        if (score[0] >= 21) {
            v = [uint256(1), 0];
        } else if (score[1] >= 21) {
            v = [uint256(0), 1];
        } else {
            v = [uint256(0), 0];

            for (uint256 d1 = 1; d1 <= 3; d1++) {
                for (uint256 d2 = 1; d2 <= 3; d2++) {
                    for (uint256 d3 = 1; d3 <= 3; d3++) {
                        uint256[2] memory pc = [pos[0], pos[1]];
                        uint256[2] memory sc = [score[0], score[1]];
                        uint256 ni = pi == 0 ? 1 : 0;

                        pc[pi] = advance(pc[pi], d1, d2, d3);
                        sc[pi] += pc[pi];

                        uint256[2] memory w = winCount(pc, sc, ni);
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

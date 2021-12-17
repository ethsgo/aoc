// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _17Parser is Parser {
    string private constant exampleInput = "target area: x=20..30, y=-10..-5";

    function parse(string memory input) internal returns (int256[4] memory ta) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        int256[] memory xs = parseInts(s);
        ta = [xs[0], xs[1], xs[2], xs[3]];
    }
}

contract _17 is _17Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        // target area
        int256[4] memory ta = parse(input);
        (uint256 ymax, uint256 count) = trajectories(ta);
        return (ymax, count);
    }

    function trajectories(int256[4] memory ta)
        private
        pure
        returns (uint256 ymax, uint256 count)
    {
        for (int256 x = 0; x < ta[1]; x++) {
            for (int256 y = ta[2]; y < -ta[2]; y++) {
                (bool hit, uint256 ym) = valid(ta, [x, y]);
                if (hit) {
                    count++;
                    if (ym > ymax) ymax = ym;
                }
            }
        }
    }

    function valid(int256[4] memory ta, int256[2] memory v)
        private
        pure
        returns (bool hit, uint256 ymax)
    {
        int256[2] memory p = [int256(0), 0];
        while (p[0] <= ta[1] && p[1] >= ta[2]) {
            p[0] += v[0];
            p[1] += v[1];
            if (
                (p[0] >= ta[0] && p[0] <= ta[1]) &&
                (p[1] >= ta[2] && p[1] <= ta[3])
            ) {
                return (true, ymax);
            }
            if (p[1] > 0 && uint256(p[1]) > ymax) {
                ymax = uint256(p[1]);
            }
            v[0] = v[0] > 0 ? v[0] - 1 : v[0] < 0 ? v[0] + 1 : int256(0);
            v[1] = v[1] - 1;
        }
    }
}

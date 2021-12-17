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
        for (int256 x = 0; x <= ta[1]; x++) {
            for (int256 y = ta[2]; y <= -ta[2]; y++) {
                (bool hit, uint256 ym) = valid(ta, x, y);
                if (hit) {
                    count++;
                    if (ym > ymax) ymax = ym;
                }
            }
        }
    }

    function valid(
        int256[4] memory ta,
        int256 vx,
        int256 vy
    ) private pure returns (bool hit, uint256 ymax) {
        int256 px;
        int256 py;
        while (px <= ta[1] && py >= ta[2]) {
            px += vx;
            py += vy;
            if (px >= ta[0] && px <= ta[1] && py >= ta[2] && py <= ta[3]) {
                return (true, ymax);
            }
            if (py > 0 && uint256(py) > ymax) {
                ymax = uint256(py);
            }
            vx = vx > 0 ? vx - 1 : vx < 0 ? vx + 1 : int256(0);
            vy = vy - 1;
        }
    }
}

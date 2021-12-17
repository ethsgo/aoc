// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _17Parser is Parser {
    string private constant exampleInput = "target area: x=20..30, y=-10..-5";

    function parse(string memory input)
        internal
        returns (int256[4] memory ta)
    {
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
        returns (uint256 ymax, uint256 count)
    {}
}

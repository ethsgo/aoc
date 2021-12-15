// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _15Parser is Parser {
    string private constant exampleInput =
        "1163751742\n"
        "1381373672\n"
        "2136511328\n"
        "3694931569\n"
        "7463417111\n"
        "1319128137\n"
        "1359912421\n"
        "3125421639\n"
        "1293138521\n"
        "2311944581\n";

    function parse(string memory input)
        internal
        returns (uint256[][] memory g)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);

        g = new uint256[][](lines.length);
        for (uint256 i = 0; i < lines.length; i++) {
            bytes memory b = bytes(lines[i]);
            g[i] = new uint256[](b.length);
            for (uint256 j = 0; j < b.length; j++) {
                g[i][j] = parseDigit(b[j]);
            }
        }
    }
}

contract _15 is _15Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[][] memory g = parse(input);
        return (p1(g), 0);
    }

    function p1(uint256[][] memory g) private view returns (uint256) {
        return shortestPath(g);
    }

    function shortestPath(uint256[][] memory g)
        private
        view
        returns (uint256)
    {
        return g.length;
    }
}

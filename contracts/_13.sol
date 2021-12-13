// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _13Parser is Parser {
    string private constant exampleInput =
        "6,10\n"
        "0,14\n"
        "9,10\n"
        "0,3\n"
        "10,4\n"
        "4,11\n"
        "6,0\n"
        "6,12\n"
        "4,1\n"
        "0,13\n"
        "10,12\n"
        "3,4\n"
        "3,0\n"
        "8,4\n"
        "1,10\n"
        "2,14\n"
        "8,10\n"
        "9,0\n"
        "\n"
        "fold along y=7\n"
        "fold along x=5\n";

    function parse(string memory input) internal returns (string[] memory r) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n");
        return lines;
    }
}

contract _13 is _13Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), 0);
    }

    function p1(string[] memory lines) private returns (uint256) {
        return lines.length;
    }
}

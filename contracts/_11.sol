// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GridParser.sol";

contract _11Parser is GridParser {
    string private constant exampleInput =
        "5483143223 "
        "2745854711 "
        "5264556173 "
        "6141336146 "
        "6357385478 "
        "4167524645 "
        "2176841721 "
        "6882881134 "
        "4846848554 "
        "5283751526 ";

    function parse(string memory input) internal returns (uint256[][] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
        return parseDigitGrid(s);
    }
}

contract _11 is _11Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), p2(parse(input)));
    }

    function p1(uint256[][] memory oct) private returns (uint256 flashes) {}

    function p2(uint256[][] memory oct) private returns (uint256 flashes) {}
}

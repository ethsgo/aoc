// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _15Parser is Parser {
    string private constant exampleInput =
        "";

    function parse(string memory input) internal returns (uint[] memory p) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);
    }
}

contract _15 is _15Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint[] memory puzzle = parse(input);
        return (p1(puzzle), 0);
    }

    function p1(uint[] memory puzzle) private view returns (uint256) {
        return 0;
    }
}
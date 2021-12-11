// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _11Parser is Parser {
    string private constant exampleInput = "";

    function parse(string memory input)
        internal
        returns (string[] memory lines)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
        lines = parseTokens(s);
    }
}

contract _11 is _11Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory lines = parse(input);
        return (p1(lines), p2(lines));
    }

    function p1(string[] memory lines) private returns (uint256 score) {}

    function p2(string[] memory lines) private returns (uint256 result) {}
}

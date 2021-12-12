// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _12Parser is Parser {
    string private constant exampleInput =
        "start-A "
        "start-b "
        "A-c "
        "A-b "
        "b-d "
        "A-end "
        "b-end ";

    function parse(string memory input)
        internal
        returns (uint256[2][] memory links)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);
    }
}

contract _12 is _12Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), p2(parse(input)));
    }

    function p1(uint256[2][] memory links) private returns (uint256 nPaths) {}

    function p2(uint256[2][] memory links) private returns (uint256 nPaths) {}
}

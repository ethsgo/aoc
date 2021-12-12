// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _12Parser is Parser {
    string private constant exampleInput = "";

    function parse(string memory input)
        internal
        pure
        returns (uint256[][] memory r)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
    }
}

contract _12 is _12Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), p2(parse(input)));
    }

    function p1(uint256[][] memory oct) private returns (uint256 r) {}

    function p2(uint256[][] memory oct) private returns (uint256 r) {}
}

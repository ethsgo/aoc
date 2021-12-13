// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _13Parser is Parser {
    string private constant exampleInput = "";

    function parse(string memory input)
        internal
        returns (uint256[][] memory r)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
    }
}

contract _13 is _13Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), 0);
    }

    function p1(uint256[][] memory oct) private returns (uint256) {
        return 0;
    }
}

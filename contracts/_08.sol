// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _08Parser is Parser {
    string private constant exampleInput = "";

    function parse(string memory input) internal returns (uint256[] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        return parseUints(s);
    }
}

contract _08 is _08Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[] memory tokens = parse(input);
        return (p1(tokens), 0);
    }

    function p1(uint256[] memory tokens) private pure returns (uint256) {
        return tokens.length;
    }
}

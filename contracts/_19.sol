// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./StringUtils.sol";

contract _19Parser is Parser {
    string private constant exampleInput = "";

    function parse(string memory input) internal returns (string[] memory xss) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n");
        xss = lines;
    }
}

contract _19 is _19Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory xss = parse(input);
        return (p1(xss), 0);
    }

    function p1(string[] memory xss) private pure returns (uint256) {
        return xss.length;
    }
}

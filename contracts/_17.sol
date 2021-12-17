// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _17Parser is Parser {
    string private constant exampleInput = "8A004A801A8002F478";

    function parse(string memory input) internal returns (uint256 p) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);
    }
}

contract _17 is _17Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), 0);
    }

    function p1(uint256) private returns (uint256) {
        return 0;
    }
}

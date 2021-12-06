// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _06Parser is Parser {
    string internal constant exampleInput = "3,4,3,1,2";

    function parse(string memory input) internal returns (uint256[9] memory) {
        uint256[] memory xs = parseUints(input);

        uint256[9] memory fishes;
        for (uint256 i = 0; i < xs.length; i++) {
            fishes[i] = fishes[i] + 1;
        }
        return fishes;
    }
}

contract _06 is _06Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
        uint256[9] memory fishes = parse(s);

        return (p1(fishes), p2(fishes));
    }

    function p1(uint256[9] memory fishes) private returns (uint256) {
        return 0;
    }

    function p2(uint256[9] memory fishes) private returns (uint256) {
        return 0;
    }
}

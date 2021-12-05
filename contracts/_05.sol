// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./StringUtils.sol";
import "hardhat/console.sol";

contract _05Parser is Parser {
    string internal constant exampleInput =
        "0,9 -> 5,9 "
        "8,0 -> 0,8 "
        "9,4 -> 3,4 "
        "2,2 -> 2,1 "
        "7,0 -> 7,4 "
        "6,4 -> 2,0 "
        "0,9 -> 2,9 "
        "3,4 -> 1,4 "
        "0,0 -> 8,8 "
        "5,5 -> 8,2 ";

    function parse(string memory input) internal returns (uint256[4][] memory) {
        uint256[] memory xs = parseUints(input);

        require(xs.length % 4 == 0);
        uint256[4][] memory segments = new uint256[4][](xs.length / 4);
        for (uint256 i = 0; i < xs.length; i += 4) {
            segments[i / 4] = [xs[i], xs[i + 1], xs[i + 2], xs[i + 3]];
        }
        return segments;
    }
}

contract _05 is _05Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        return (p1(parse(s)), 0);
    }

    function p1(uint256[4][] memory segments) private returns (uint256) {
        return segments.length;
    }
}

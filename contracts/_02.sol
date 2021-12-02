// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "hardhat/console.sol";

contract _02 is Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        /*
        uint256[] memory xs = parseInts(input);
        if (xs.length == 0) {
            xs = parseInts("forward 5 down 5 forward 8 up 3 down 8 forward 2");
        }
        return (p1(xs), p2(xs));
        */
        uint8[][] memory tokens = parseTokens(
            "forward 5 down 5 forward 8 up 3 down 8 forward 2"
        );
        // string s0 = string(tokens[0]);
        console.log(tokens[0][0]);
        return (tokens.length, 0);
    }

    function p1(uint256[] memory xs) private pure returns (uint256) {
        uint256 increases;
        for (uint256 i = 1; i < xs.length; i++) {
            if (xs[i - 1] < xs[i]) {
                increases++;
            }
        }
        return increases;
    }

    function p2(uint256[] memory xs) private pure returns (uint256) {
        return 0;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Parser.sol";

contract C20_01 is Parser {
    function p1(string memory input) external returns (uint) {
        uint[] memory xs = parseInts(input);
        for (uint i = 0; i < xs.length; i++) {
            for (uint j = i + 1; j < xs.length; j++) {
                if (xs[i] + xs[j] == 2020) {
                    return xs[i] * xs[j];
                }
            }
        }
        revert();
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Parser.sol";

contract C20_01 is Parser {
    function main(string memory input) external returns (uint, uint) {
        uint[] memory xs = parseInts(input);
        if (xs.length == 0) {
            xs = parseInts("[1721, 979, 366, 299, 675, 1456]");
        }

        return (p1(xs), 0); // p2(xs));
    }

    function p1(uint[] memory xs) private pure returns (uint) {
        for (uint i = 0; i < xs.length; i++) {
            for (uint j = i + 1; j < xs.length; j++) {
                if (xs[i] + xs[j] == 2020) {
                    return xs[i] * xs[j];
                }
            }
        }
        revert();
    }

    function p2(uint[] memory xs) private pure returns (uint) {
        for (uint i = 0; i < xs.length; i++) {
            for (uint j = i + 1; j < xs.length; j++) {
                for (uint k = j + 1; k < xs.length; k++) {
                    if (xs[i] + xs[j] + xs[k] == 2020) {
                        return xs[i] * xs[j] * xs[k];
                    }
                }
            }
        }
        revert();
    }
}

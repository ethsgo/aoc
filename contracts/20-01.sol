// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract C20_01 is Parser {
    function main(string memory input) external returns (uint, uint) {
        uint[] memory xs = parseInts(input);
        if (xs.length == 0) {
            xs = parseInts("[1721, 979, 366, 299, 675, 1456]");
        }

        return (p1(xs), p2(xs));
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

    // mappings cannot be created dynamically, you have to assign them
    // from a state variable.
    mapping(uint => bool) m;

    function p2(uint[] memory xs) private returns (uint) {
        // mappings cannot be deleted, but it's fine, we only run this part once.
        for (uint i = 0; i < xs.length; i++) {
            m[xs[i]] = true;
        }

        for (uint i = 0; i < xs.length; i++) {
            for (uint j = i + 1; j < xs.length; j++) {
                uint d = xs[i] + xs[j];
                if (d <= 2020) {
                    uint xk = 2020 - d;
                    if (m[xk] == true) {
                        return xs[i] * xs[j] * xk;
                    }
                }
            }
        }
        revert();
    }
}

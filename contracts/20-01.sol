// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract C20_01 is Parser {
    function main(string memory input) external returns (uint256, uint256) {
        uint256[] memory xs = parseInts(input);
        if (xs.length == 0) {
            xs = parseInts("[1721, 979, 366, 299, 675, 1456]");
        }

        return (p1(xs), p2(xs));
    }

    function p1(uint256[] memory xs) private pure returns (uint256) {
        for (uint256 i = 0; i < xs.length; i++) {
            for (uint256 j = i + 1; j < xs.length; j++) {
                if (xs[i] + xs[j] == 2020) {
                    return xs[i] * xs[j];
                }
            }
        }
        revert();
    }

    // mappings cannot be created dynamically, you have to assign them
    // from a state variable.
    mapping(uint256 => bool) m;

    function p2(uint256[] memory xs) private returns (uint256) {
        // mappings cannot be deleted, but it's fine, we only run this part once.
        for (uint256 i = 0; i < xs.length; i++) {
            m[xs[i]] = true;
        }

        for (uint256 i = 0; i < xs.length; i++) {
            for (uint256 j = i + 1; j < xs.length; j++) {
                uint256 d = xs[i] + xs[j];
                if (d <= 2020) {
                    uint256 xk = 2020 - d;
                    if (m[xk] == true) {
                        return xs[i] * xs[j] * xk;
                    }
                }
            }
        }
        revert();
    }
}

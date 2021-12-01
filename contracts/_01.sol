// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _01 is Parser {
    function main(string memory input) external returns (uint256, uint256) {
        uint256[] memory xs = parseInts(input);
        if (xs.length == 0) {
            xs = parseInts(
                "[199, 200, 208, 210, 200, 207, 240, 269, 260, 263]"
            );
        }
        return (p1(xs), p2(xs));
    }

    /// Return the number of changes in `xs` that are greater than the previous value.
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
        uint256 increases;
        // Need at least 3 samples for a measurement.
        if (xs.length < 3) return 0;
        for (uint256 i = 3; i < xs.length; i++) {
            // The middle two values are the same in both windows, so they cancel
            // out and we can just compare the extremes.
            if (xs[i - 3] < xs[i]) {
                increases++;
            }
        }
        return increases;
    }
}

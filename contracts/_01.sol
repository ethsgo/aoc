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

    function p1(uint256[] memory xs) private pure returns (uint256) {
        uint256 increases;
        // Assume 0 is not a valid depth, so we can treat 0 (the default value
        // of uninitialized Solidity variables) to indicate an unset previous value.
        uint256 previous;
        for (uint256 i = 0; i < xs.length; i++) {
            if (previous > 0 && previous < xs[i]) {
                increases++;
            }
            previous = xs[i];
        }

        return increases;
    }

    function p2(uint256[] memory xs) private pure returns (uint256) {
        uint256 increases;
        // Need at least 3 samples for a measurement.
        if (xs.length < 3) return 0;
        // Sliding window of measurements
        uint256[3] memory mx = [xs[0], xs[1], 0];
        // Index into the the sliding window.
        uint256 mi = 2;
        // Assume that a valid sum will never be 0, so we can treat 0 as null.
        uint256 previousSum;
        for (uint256 i = 2; i < xs.length; i++) {
            mx[mi] = xs[i];
            mi = (mi + 1) % 3;
            uint256 sum = mx[0] + mx[1] + mx[2];
            if (previousSum > 0 && previousSum < sum) {
                increases++;
            }
            previousSum = sum;
        }
        return increases;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayUtils {
    function sum(uint256[] memory xs) internal pure returns (uint256) {
        uint256 c = 0;
        for (uint256 i = 0; i < xs.length; i++) {
            c += xs[i];
        }
        return c;
    }
}

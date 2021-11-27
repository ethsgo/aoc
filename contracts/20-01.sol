// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract C20_01 {
    function p1() public pure returns (uint) {
        uint256[6] memory xs = [uint256(1721), 979, 366, 299, 675, 1456];
        for (uint256 i = 0; i < xs.length; i++) {
            for (uint256 j = i + 1; j < xs.length; j++) {
                if (xs[i] + xs[j] == 2020) {
                    return xs[i] * xs[j];
                }
            }
        }
        revert();
    }
}

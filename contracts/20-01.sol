// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract C20_01 {
    function p1() public pure returns (uint) {
        uint[6] memory xs = [uint(1721), 979, 366, 299, 675, 1456];
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

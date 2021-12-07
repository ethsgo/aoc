// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MathUtils {
    /// Return the absolute difference of the given numbers
    function absdiff(uint256 x, uint256 y) internal pure returns (uint256) {
        return (x < y) ? (y - x) : (x - y);
    }

    /// Return the minimum of two numbers
    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return (x <= y) ? x : y;
    }

    /// Return the minimum of three numbers
    function min(
        uint256 x,
        uint256 y,
        uint256 z
    ) internal pure returns (uint256) {
        if (x <= y) {
            return (x <= z) ? x : z;
        } else {
            return (y <= z) ? y : z;
        }
    }

    /// Return the maximum of two numbers
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return (x >= y) ? x : y;
    }

    /// Return the maximum of three numbers
    function max(
        uint256 x,
        uint256 y,
        uint256 z
    ) internal pure returns (uint256) {
        if (x >= y) {
            return (x >= z) ? x : z;
        } else {
            return (y >= z) ? y : z;
        }
    }
}

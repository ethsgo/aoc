// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./StringUtils.sol";
import "hardhat/console.sol";

contract _05Parser is Parser {
    string internal constant exampleInput =
        "0,9 -> 5,9 "
        "8,0 -> 0,8 "
        "9,4 -> 3,4 "
        "2,2 -> 2,1 "
        "7,0 -> 7,4 "
        "6,4 -> 2,0 "
        "0,9 -> 2,9 "
        "3,4 -> 1,4 "
        "0,0 -> 8,8 "
        "5,5 -> 8,2 ";

    function parse(string memory input) internal returns (uint256[4][] memory) {
        uint256[] memory xs = parseUints(input);

        require(xs.length % 4 == 0);
        uint256[4][] memory segments = new uint256[4][](xs.length / 4);
        for (uint256 i = 0; i < xs.length; i += 4) {
            segments[i / 4] = [xs[i], xs[i + 1], xs[i + 2], xs[i + 3]];
        }
        return segments;
    }
}

contract MathUtils {
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

contract _05 is _05Parser, MathUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
        uint256[4][] memory segments = parse(s);
        return (p1(segments), p2(segments));
    }

    /// Mappings cannot be created in memory (yet), and mappings cannot be
    /// cleared either, so create two separate mappings, one for each part of
    /// the puzzle.
    mapping(uint256 => uint256) private gridP1;
    mapping(uint256 => uint256) private gridP2;

    function p1(uint256[4][] memory segments) private returns (uint256) {
        return countOverlap(filterHVSegments(segments), gridP1);
    }

    function p2(uint256[4][] memory segments) private returns (uint256) {
        return countOverlap(segments, gridP2);
    }

    /// Return only horizontal or vertical segments from the given segments.
    function filterHVSegments(uint256[4][] memory segments)
        private
        pure
        returns (uint256[4][] memory)
    {
        // Dynamic memory arrays cannot be resized, so we need to iterate twice,
        // first to find the count, and then to fill in the values.
        uint256 c = 0;
        for (uint256 i = 0; i < segments.length; i++) {
            uint256[4] memory s = segments[i];
            if (s[0] == s[2] || s[1] == s[3]) c++;
        }
        uint256[4][] memory result = new uint256[4][](c);
        c = 0;
        for (uint256 i = 0; i < segments.length; i++) {
            uint256[4] memory s = segments[i];
            if (s[0] == s[2] || s[1] == s[3]) result[c++] = s;
        }
        return result;
    }

    /// Return (maxX, maxY) from amongst the given segments.
    function bounds(uint256[4][] memory segments)
        private
        pure
        returns (uint256, uint256)
    {
        uint256 maxX;
        uint256 maxY;
        for (uint256 i = 0; i < segments.length; i++) {
            uint256[4] memory s = segments[i];
            maxX = max(maxX, s[0], s[2]);
            maxY = max(maxY, s[1], s[3]);
        }
        return (maxX, maxY);
    }

    function countOverlap(
        uint256[4][] memory segments,
        mapping(uint256 => uint256) storage grid
    ) private returns (uint256) {
        (uint256 maxX, ) = bounds(segments);

        uint256 c = 0;

        for (uint256 i = 0; i < segments.length; i++) {
            // Create int variants for reduce casting noise below.
            int256 s0 = int256(segments[i][0]);
            int256 s1 = int256(segments[i][1]);
            int256 s2 = int256(segments[i][2]);
            int256 s3 = int256(segments[i][3]);

            int256 dx = s2 - s0;
            int256 dy = s3 - s1;
            // Keep only the sign
            dx = dx == 0 ? int256(0) : (dx < 0 ? -1 : int256(1));
            dy = dy == 0 ? int256(0) : (dy < 0 ? -1 : int256(1));

            int256 x = s0;
            int256 y = s1;
            while (x != s2 || y != s3) {
                if ((grid[(uint256(y) * maxX) + uint256(x)] += 1) == 2) {
                    c++;
                }
                x += dx;
                y += dy;
            }
            if ((grid[(uint256(y) * maxX) + uint256(x)] += 1) == 2) {
                c++;
            }
        }

        return c;
    }
}

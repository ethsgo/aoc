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

contract _05 is _05Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        return (p1(parse(s)), 0);
    }

    function p1(uint256[4][] memory segments) private pure returns (uint256) {
        segments = filterHVSegments(segments);
        (uint256 maxX, uint256 maxY) = bounds(segments);

        return maxX;
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

    /// Return the maximum of up to three numbers
    function max(
        uint256 x,
        uint256 y,
        uint256 z
    ) private pure returns (uint256) {
        if (x >= y) {
            return (x >= z) ? x : z;
        } else {
            return (y >= z) ? y : z;
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./MathUtils.sol";

contract _07Parser is Parser {
    string private constant exampleInput = "16,1,2,0,4,2,7,1,2,14";

    function parse(string memory input) internal returns (uint256[] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        return parseUints(s);
    }
}

contract ArrayUtils {
    function sum(uint256[] memory xs) internal pure returns (uint256) {
        uint256 c = 0;
        for (uint256 i = 0; i < xs.length; i++) {
            c += xs[i];
        }
        return c;
    }
}

contract _07 is _07Parser, ArrayUtils, MathUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[] memory crabs = parse(input);
        return (p1(crabs), p2(crabs));
    }

    function p1(uint256[] memory xs) private pure returns (uint256) {
        // Median minimizes the absolute distance.
        return fuel(xs, median(xs));
    }

    function median(uint256[] memory xs) private pure returns (uint256) {
        return 0;
    }

    function fuel(uint256[] memory xs, uint256 m)
        private
        pure
        returns (uint256)
    {
        uint256 c = 0;
        for (uint256 i = 0; i < xs.length; i++) {
            c += absdiff(xs[i], m);
        }
        return c;
    }

    function p2(uint256[] memory xs) private pure returns (uint256) {
        // Arithmetic mean minimizes square of distance. In our case we want to
        // minimize (n^2 + n) / 2, which is close enough such that trying the
        // floor and the ceiling of the mean works.
        uint256 m = sum(xs) / xs.length;

        return min(fuel2(xs, m), fuel2(xs, m + 1));
    }

    function fuel2(uint256[] memory xs, uint256 m)
        private
        pure
        returns (uint256)
    {
        uint256 c = 0;
        for (uint256 i = 0; i < xs.length; i++) {
            uint256 d = absdiff(xs[i], m);
            c += (d * (d + 1)) / 2;
        }
        return c;
    }
}

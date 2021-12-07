// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _07Parser is Parser {
    string private constant exampleInput = "16,1,2,0,4,2,7,1,2,14";

    function parse(string memory input) internal returns (uint256[] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        return parseUints(s);
    }
}

contract _07 is _07Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[] memory crabs = parse(input);
        return (p1(crabs), p2(crabs));
    }

    function minmax(uint256[] memory xs) private returns (uint256, uint256) {
        uint256 min = xs[0];
        uint256 max = xs[0];
        for (uint256 i = 0; i < xs.length; i++) {
            uint256 x = xs[i];
            if (x < min) {
                min = x;
            }
            if (x > max) {
                max = x;
            }
        }
        return (min, max);
    }

    function fuel(
        uint256[] memory crabs,
        uint256 position,
        uint256 currentMin
    ) private pure returns (uint256) {
        uint256 c = 0;
        for (uint256 i = 0; i < crabs.length; i++) {
            c += position < crabs[i]
                ? crabs[i] - position
                : position - crabs[i];
            if (c >= currentMin) {
                return c;
            }
        }
        return c;
    }

    function p1(uint256[] memory crabs) private returns (uint256) {
        (uint256 s, uint256 e) = minmax(crabs);
        uint256 m = type(uint256).max;
        for (; s <= e; s++) {
            uint256 f = fuel(crabs, s, m);
            if (f < m) {
                m = f;
            }
        }
        return m;
    }

    function p2(uint256[] memory crabs) private pure returns (uint256) {
        return 0;
    }
}

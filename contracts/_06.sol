// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _06Parser is Parser {
    string internal constant exampleInput = "3,4,3,1,2";

    function parse(string memory input) internal returns (uint256[9] memory) {
        uint256[] memory xs = parseUints(input);

        uint256[9] memory fishes;
        for (uint256 i = 0; i < xs.length; i++) {
            fishes[xs[i]] = fishes[xs[i]] + 1;
        }
        return fishes;
    }
}

contract _06 is _06Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
        uint256[9] memory fishes = parse(s);

        return (p1(fishes), p2(fishes));
    }

    function grow(uint256[9] memory fishes, uint256 ndays)
        private
        pure
        returns (uint256)
    {
        for (; ndays > 0; ndays--) {
            uint256[9] memory newFishes;
            for (uint256 i = 0; i < fishes.length; i++) {
                uint256 v = fishes[i];
                if (i == 0) {
                    newFishes[6] = v;
                    newFishes[8] = v;
                } else {
                    newFishes[i - 1] = newFishes[i - 1] + v;
                }
            }
            fishes = newFishes;
        }

        return sum(fishes);
    }

    function sum(uint256[9] memory xs) private pure returns (uint256) {
        uint256 c = 0;
        for (uint256 i = 0; i < xs.length; i++) {
            c += xs[i];
        }
        return c;
    }

    function p1(uint256[9] memory fishes) private pure returns (uint256) {
        return grow(fishes, 80);
    }

    function p2(uint256[9] memory fishes) private pure returns (uint256) {
        return grow(fishes, 256);
    }
}

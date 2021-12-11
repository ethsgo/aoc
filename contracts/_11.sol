// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GridParser.sol";

contract _11Parser is GridParser {
    string private constant exampleInput =
        "5483143223 "
        "2745854711 "
        "5264556173 "
        "6141336146 "
        "6357385478 "
        "4167524645 "
        "2176841721 "
        "6882881134 "
        "4846848554 "
        "5283751526 ";

    function parse(string memory input) internal returns (uint256[][] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
        return parseDigitGrid(s);
    }
}

contract _11 is _11Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), p2(parse(input)));
    }

    uint256[2][] private stack;

    function p1(uint256[][] memory oct) private returns (uint256) {
        return sim(oct, 100);
    }

    function sim(uint256[][] memory oct, uint256 steps)
        private
        returns (uint256 flashes)
    {
        for (; steps > 0; steps--) flashes += step(oct);
    }

    function step(uint256[][] memory oct) private returns (uint256 flashes) {
        delete stack;

        for (uint256 y = 0; y < oct.length; y++) {
            for (uint256 x = 0; x < oct[y].length; x++) {
                oct[y][x]++;
                if (oct[y][x] > 9) stack.push([y, x]);
            }
        }

        while (stack.length > 0) {
            uint256[2] memory qn = stack[stack.length - 1];
            stack.pop();
            uint256 y = qn[0];
            uint256 x = qn[1];
            flashes++;
            for (int256 dy = -1; dy <= 1; dy++) {
                for (int256 dx = -1; dx <= 1; dx++) {
                    if (dy == 0 && dx == 0) continue;

                    if (int256(y) + dy < 0) continue;
                    uint256 ny = uint256(int256(y) + dy);
                    if (ny >= oct.length) continue;

                    if (int256(x) + dx < 0) continue;
                    uint256 nx = uint256(int256(x) + dx);
                    if (nx >= oct[ny].length) continue;

                    oct[ny][nx]++;
                    if (oct[ny][nx] == 10) {
                        stack.push([ny, nx]);
                    }
                }
            }
        }

        for (uint256 y = 0; y < oct.length; y++) {
            for (uint256 x = 0; x < oct[y].length; x++) {
                if (oct[y][x] > 9) oct[y][x] = 0;
            }
        }
    }

    function p2(uint256[][] memory oct) private returns (uint256 steps) {
        while (!allZeroes(oct)) {
            step(oct);
            steps++;
        }
    }

    function allZeroes(uint256[][] memory oct) private pure returns (bool) {
        for (uint256 y = 0; y < oct.length; y++) {
            for (uint256 x = 0; x < oct[y].length; x++) {
                if (oct[y][x] != 0) return false;
            }
        }
        return true;
    }
}

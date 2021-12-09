// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./ArrayUtils.sol";

contract _09Parser is Parser {
    string private constant exampleInput =
        "2199943210 "
        "3987894921 "
        "9856789892 "
        "8767896789 "
        "9899965678 ";

    function parse(string memory input) internal returns (uint256[][] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);

        uint256[][] memory result = new uint256[][](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            bytes memory b = bytes(tokens[i]);
            result[i] = new uint256[](b.length);
            for (uint256 j = 0; j < b.length; j++) {
                result[i][j] = parseDigit(b[j]);
            }
        }
        return result;
    }
}

contract _09 is _09Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[][] memory heightmap = parse(input);
        return (p1(heightmap), p2(heightmap));
    }

    function p1(uint256[][] memory heightmap) private pure returns (uint256) {
        uint256 c = 0;
        for (int256 y = 0; y < int256(heightmap.length); y++) {
            uint256[] memory row = heightmap[uint256(y)];
            for (int256 x = 0; x < int256(row.length); x++) {
                if (isLowPoint(heightmap, y, x)) {
                    c += (row[uint256(x)] + 1);
                }
            }
        }
        return c;
    }

    function isLowPoint(
        uint256[][] memory heightmap,
        int256 y,
        int256 x
    ) private pure returns (bool) {
        uint256 pt = heightmap[uint256(y)][uint256(x)];
        return (pt < neighbour(heightmap, y - 1, x) &&
            pt < neighbour(heightmap, y, x + 1) &&
            pt < neighbour(heightmap, y, x - 1) &&
            pt < neighbour(heightmap, y + 1, x));
    }

    function neighbour(
        uint256[][] memory heightmap,
        int256 y,
        int256 x
    ) private pure returns (uint256) {
        if (y < 0 || x < 0) return type(uint256).max;
        uint256 uy = uint256(y);
        uint256 ux = uint256(x);
        if (uy >= heightmap.length || ux >= heightmap[uy].length)
            return type(uint256).max;
        return heightmap[uy][ux];
    }

    function p2(uint256[][] memory heightmap) private returns (uint256) {
        // Basin sizes
        uint256[3] memory basinSizes = [uint256(0), 0, 0];
        for (int256 y = 0; y < int256(heightmap.length); y++) {
            uint256[] memory row = heightmap[uint256(y)];
            for (int256 x = 0; x < int256(row.length); x++) {
                // Unexplored low point
                if (
                    row[uint256(x)] != explored && isLowPoint(heightmap, y, x)
                ) {
                    uint256 bsz = basinSize(heightmap, y, x);
                    for (uint256 z = 0; z < basinSizes.length; z++) {
                        if (basinSizes[z] < bsz) {
                            basinSizes[z] = bsz;
                            break;
                        }
                    }
                }
            }
        }

        return basinSizes[0];
    }

    uint256 private constant explored = type(uint256).max;
    struct Next {
        int256 x;
        int256 y;
        uint256 pt;
    }
    // In memory dynamic arrays cannot be resized, so we need to store this
    // resizable array for use by the basinSize function.
    Next[] private frontier;

    function basinSize(
        uint256[][] memory heightmap,
        int256 y,
        int256 x
    ) private returns (uint256) {
        delete frontier;
        uint256 c = 1;
        pushFrontier(y, x, heightmap[uint256(y)][uint256(x)]);
        heightmap[uint256(y)][uint256(x)] = explored;
        return c;
        for (int256 y = 0; y < int256(heightmap.length); y++) {
            uint256[] memory row = heightmap[uint256(y)];
            for (int256 x = 0; x < int256(row.length); x++) {
                if (isLowPoint(heightmap, y, x)) {
                    c += (row[uint256(x)] + 1);
                }
            }
        }
        return c;
    }

    function pushFrontier(
        int256 y,
        int256 x,
        uint256 pt
    ) private {
        frontier.push(Next({y: y - 1, x: x, pt: pt}));
        frontier.push(Next({y: y, x: x + 1, pt: pt}));
        frontier.push(Next({y: y + 1, x: x, pt: pt}));
        frontier.push(Next({y: y, x: x - 1, pt: pt}));
    }
}

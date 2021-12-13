// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "hardhat/console.sol";

contract _13Parser is Parser {
    string private constant exampleInput =
        "6,10\n"
        "0,14\n"
        "9,10\n"
        "0,3\n"
        "10,4\n"
        "4,11\n"
        "6,0\n"
        "6,12\n"
        "4,1\n"
        "0,13\n"
        "10,12\n"
        "3,4\n"
        "3,0\n"
        "8,4\n"
        "1,10\n"
        "2,14\n"
        "8,10\n"
        "9,0\n"
        "\n"
        "fold along y=7\n"
        "fold along x=5\n";

    struct Sheet {
        uint256[2][] dots;
        uint256[2][] folds;
    }

    function parse(string memory input) internal returns (Sheet memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);
        // Find the first empty line. This lets us determine the size of the
        // arrays.
        uint256 dotCount = 0;
        while (bytes(lines[dotCount]).length > 0) {
            console.log(lines[dotCount]);
            dotCount++;
        }
        uint256[2][] memory dots = new uint256[2][](dotCount);
        uint256[2][] memory folds = new uint256[2][](
            lines.length - dotCount - 1
        );

        bool parseDot = true;
        for (uint256 i = 0; i < lines.length; i++) {
            if (bytes(lines[i]).length == 0) {
                parseDot = false;
                continue;
            }
            if (parseDot) {
                string[] memory ab = split(lines[i], ",");
                dots[i] = [parseUint(ab[0]), parseUint(ab[1])];
            } else {
                string[] memory ab = split(lines[i], "=");
                bytes memory b = bytes(ab[0]);
                uint256 v = parseUint(ab[1]);
                if (b[b.length - 1] == "y") {
                    folds[i - dotCount - 1] = [0, v];
                } else {
                    folds[i - dotCount - 1] = [v, 0];
                }
            }
        }

        return Sheet({dots: dots, folds: folds});
    }
}

contract _13 is _13Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        return (p1(parse(input)), 0);
    }

    function p1(Sheet memory sheet) private returns (uint256) {
        return sheet.dots.length;
    }
}

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
        while (bytes(lines[dotCount]).length > 0) dotCount++;
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
    function main(string calldata input)
        external
        returns (uint256, string memory)
    {
        Sheet memory sheet = parse(input);
        return (p1(sheet), p2(sheet));
    }

    function p1(Sheet memory sheet) private pure returns (uint256) {
        uint256[2][] memory dots = fold(sheet.dots, sheet.folds[0]);
        return dots.length;
    }

    function p2(Sheet memory sheet) private pure returns (string memory) {
        uint256[2][] memory dots = sheet.dots;
        for (uint256 i = 0; i < sheet.folds.length; i++)
            dots = fold(dots, sheet.folds[i]);
        return pretty(viz(dots));
    }

    function fold(uint256[2][] memory dots, uint256[2] memory f)
        private
        pure
        returns (uint256[2][] memory folded)
    {
        folded = new uint256[2][](0);
        for (uint256 i = 0; i < dots.length; i++) {
            uint256[2] memory dot;
            if (f[0] == 0) {
                if (dots[i][1] < f[1]) {
                    dot = dots[i];
                } else {
                    dot = [dots[i][0], f[1] - (dots[i][1] - f[1])];
                }
            } else {
                if (dots[i][0] < f[0]) {
                    dot = dots[i];
                } else {
                    dot = [f[0] - (dots[i][0] - f[0]), dots[i][1]];
                }
            }
            folded = appendIfNew(folded, dot);
        }
    }

    /// Prefix with a "\n" to have nicer printing in JS.
    function pretty(string memory s) private pure returns (string memory) {
        return string(bytes.concat("\n", bytes(s)));
    }

    function viz(uint256[2][] memory dots)
        private
        pure
        returns (string memory)
    {
        bytes memory lines;
        (uint256 mx, uint256 my) = mxmy(dots);
        for (uint256 y = 0; y <= my; y++) {
            bytes memory s;
            for (uint256 x = 0; x <= mx; x++) {
                s = bytes.concat(s, bytes(contains(dots, [x, y]) ? "#" : "."));
            }
            lines = bytes.concat(lines, s, bytes("\n"));
        }
        return string(lines);
    }

    /// Return a copy of dots, appending the given dot if it is not already there.
    function appendIfNew(uint256[2][] memory dots, uint256[2] memory dot)
        private
        pure
        returns (uint256[2][] memory copy)
    {
        if (contains(dots, dot)) {
            copy = new uint256[2][](dots.length);
        } else {
            copy = new uint256[2][](dots.length + 1);
            copy[dots.length] = dot;
        }
        for (uint256 i = 0; i < dots.length; i++) copy[i] = dots[i];
    }

    function contains(uint256[2][] memory dots, uint256[2] memory dot)
        private
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < dots.length; i++)
            if (dots[i][0] == dot[0] && dots[i][1] == dot[1]) return true;
        return false;
    }

    function mxmy(uint256[2][] memory dots)
        private
        pure
        returns (uint256 mx, uint256 my)
    {
        for (uint256 i = 0; i < dots.length; i++) {
            if (dots[i][0] > mx) mx = dots[i][0];
            if (dots[i][1] > my) my = dots[i][1];
        }
    }
}

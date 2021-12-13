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
        // Parsing the sheet is quite expensive, so share it between parts even
        // when the folding happens in place. The modifications made by p1 have
        // no functional impact on the result of p2.
        return (p1(sheet), p2(sheet));
    }

    function p1(Sheet memory sheet) private pure returns (uint256) {
        fold(sheet.dots, sheet.folds[0]);
        return unique(sheet.dots).length;
    }

    function p2(Sheet memory sheet) private pure returns (string memory) {
        for (uint256 i = 0; i < sheet.folds.length; i++)
            fold(sheet.dots, sheet.folds[i]);
        return pretty(viz(unique(sheet.dots)));
    }

    function fold(uint256[2][] memory dots, uint256[2] memory f) private pure {
        for (uint256 i = 0; i < dots.length; i++) {
            if (f[0] == 0 && dots[i][1] > f[1]) {
                dots[i] = [dots[i][0], f[1] - (dots[i][1] - f[1])];
            } else if (f[1] == 0 && dots[i][0] > f[0]) {
                dots[i] = [f[0] - (dots[i][0] - f[0]), dots[i][1]];
            }
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

    function unique(uint256[2][] memory xs)
        private
        pure
        returns (uint256[2][] memory copy)
    {
        uint256 end = xs.length;
        for (uint256 i = 0; i < end; i++) {
            for (uint256 j = i + 1; j < end; j++) {
                if (equal(xs[i], xs[j])) {
                    xs[j] = xs[--end];
                }
            }
        }
        copy = new uint256[2][](end);
        for (uint256 i = 0; i < end; i++) copy[i] = xs[i];
    }

    function equal(uint256[2] memory d1, uint256[2] memory d2)
        private
        pure
        returns (bool)
    {
        return d1[0] == d2[0] && d1[1] == d2[1];
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

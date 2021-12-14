// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./ArrayUtils.sol";
import "hardhat/console.sol";

contract _14Parser is Parser {
    string private constant exampleInput =
        "NNCB\n"
        "\n"
        "CH -> B\n"
        "HH -> N\n"
        "CB -> H\n"
        "NH -> C\n"
        "HB -> C\n"
        "HC -> B\n"
        "HN -> C\n"
        "NN -> C\n"
        "BH -> H\n"
        "NC -> B\n"
        "NB -> B\n"
        "BN -> B\n"
        "BB -> N\n"
        "BC -> B\n"
        "CC -> N\n"
        "CN -> C\n";

    mapping(bytes2 => bytes1) internal rules;

    struct Puzzle {
        bytes1[] template;
        bytes1[] elements;
        bytes2[] pairs;
    }

    /// Parse the rules into the `rules` mapping, and return the template and
    /// the unique keys of the rules mapping.
    function parse(string memory input) internal returns (Puzzle memory p) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);

        bytes1[] memory uniq = new bytes1[](0);
        // First line is the template
        bytes memory by = bytes(lines[0]);
        p.template = new bytes1[](by.length);
        for (uint256 i = 0; i < by.length; i++) {
            p.template[i] = by[i];
            uniq = appendIfNewB1(uniq, by[i]);
        }

        // Third line onwards are the rules
        p.pairs = new bytes2[](lines.length - 2);
        for (uint256 i = 2; i < lines.length; i++) {
            by = bytes(lines[i]);
            // First two characters are the keys, last character is the value.
            bytes2 key = pair(by[0], by[1]);
            bytes1 v = by[by.length - 1];
            rules[key] = v;
            p.pairs[i - 2] = key;
            uniq = appendIfNewB1(uniq, by[0]);
            uniq = appendIfNewB1(uniq, by[1]);
            uniq = appendIfNewB1(uniq, v);
        }

        p.elements = uniq;
    }

    function pair(bytes1 a, bytes1 b) internal pure returns (bytes2) {
        return a | (bytes2(b) >> 8);
    }

    function containsB1(bytes1[] memory xs, bytes1 u)
        private
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < xs.length; i++) {
            if (xs[i] == u) return true;
        }
        return false;
    }

    function appendIfNewB1(bytes1[] memory xs, bytes1 x)
        private
        pure
        returns (bytes1[] memory)
    {
        if (containsB1(xs, x)) {
            return xs;
        }
        bytes1[] memory copy = new bytes1[](xs.length + 1);
        copy[xs.length] = x;
        for (uint256 i = 0; i < xs.length; i++) copy[i] = xs[i];
        return copy;
    }
}

contract _14 is _14Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        Puzzle memory puzzle = parse(input);
        return (p1(puzzle), p2(puzzle));
    }

    function p1(Puzzle memory puzzle) private view returns (uint256) {
        return sim(puzzle, 10);
    }

    function p2(Puzzle memory puzzle) private view returns (uint256) {
        return sim(puzzle, 40);
    }

    function elementId(Puzzle memory puzzle, bytes1 e)
        private
        pure
        returns (uint256 i)
    {
        for (; i < puzzle.elements.length; i++)
            if (e == puzzle.elements[i]) break;
    }

    function pairId(Puzzle memory puzzle, bytes2 p)
        private
        pure
        returns (uint256 i)
    {
        for (; i < puzzle.pairs.length; i++) if (p == puzzle.pairs[i]) break;
    }

    function sim(Puzzle memory puzzle, uint256 steps)
        private
        view
        returns (uint256)
    {
        bytes1[] memory t = puzzle.template;
        bytes1[] memory elements = puzzle.elements;
        bytes2[] memory pairs = puzzle.pairs;

        uint256[] memory c1 = new uint256[](elements.length);
        for (uint256 i = 0; i < t.length; i++) {
            c1[elementId(puzzle, t[i])]++;
        }

        uint256[] memory c2 = new uint256[](pairs.length);
        for (uint256 i = 0; i < t.length - 1; i++) {
            bytes2 p = pair(t[i], t[i + 1]);
            c2[pairId(puzzle, p)]++;
        }

        for (; steps > 0; steps--) {
            uint256[] memory c2copy = copyUints(c2);
            for (uint256 i = 0; i < pairs.length; i++) {
                bytes2 p = pairs[i];
                uint256 v = c2copy[pairId(puzzle, p)];
                if (v == 0) continue;
                bytes1 n = rules[p];
                c1[elementId(puzzle, n)] += v;
                c2[pairId(puzzle, p)] -= v;
                c2[pairId(puzzle, pair(p[0], n))] += v;
                c2[pairId(puzzle, pair(n, p[1]))] += v;
            }
        }

        uint256 min = type(uint256).max;
        uint256 max = 0;
        for (uint256 i = 0; i < elements.length; i++) {
            uint256 c = c1[elementId(puzzle, elements[i])];
            if (c > 0) {
                if (c < min) min = c;
                if (c > max) max = c;
            }
        }
        return max - min;
    }
}

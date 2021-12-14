// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
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

contract _14 is _14Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        Puzzle memory puzzle = parse(input);
        return (p1(puzzle), 0);
    }

    function p1(Puzzle memory puzzle) private returns (uint256) {
        return sim(puzzle, 0);
    }

    mapping(bytes1 => uint256) private c1;
    mapping(bytes2 => uint256) private c2;

    function sim(Puzzle memory puzzle, uint256 steps)
        private
        returns (uint256)
    {
        bytes1[] memory t = puzzle.template;
        for (uint256 i = 0; i < t.length; i++) {
            c1[t[i]]++;
        }
        for (uint256 i = 0; i < t.length - 1; i++) {
            c2[pair(t[i], t[i + 1])]++;
        }

        bytes2[] memory pairs = puzzle.pairs;
        for (; steps > 0; steps--) {
            console.log("step", steps);
            for (uint256 i = 0; i < pairs.length; i++) {
                bytes2 p = pairs[i];
                uint256 v = c2[p];
                if (v == 0) continue;
                bytes1 n = rules[p];
                console.log(string(bytes.concat(p, " ", n)), v);
                c1[n] += v;
                c2[p] -= v;
                c2[pair(p[0], n)] += v;
                c2[pair(n, p[1])] += v;
            }
        }

        bytes1[] memory c1Keys = puzzle.elements;
        uint256 min = type(uint256).max;
        uint256 max = 0;
        for (uint256 i = 0; i < c1Keys.length; i++) {
            uint256 c = c1[c1Keys[i]];
            if (c > 0) {
                if (c < min) min = c;
                if (c > max) max = c;
            }
        }
        return max - min;
    }
}

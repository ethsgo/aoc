// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

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

    mapping(bytes1 => uint256) private knownIds;
    uint256 private nextId;
    mapping(uint256 => uint256) private rules;

    /// Parse the rules into the `rules` mapping, and return the template.
    ///
    /// Strings are encoded as uints. The key for a given by the ruleKey function.
    function parse(string memory input)
        internal
        returns (uint256[] memory template)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);

        // First line is the template
        bytes memory by = bytes(lines[0]);
        template = new uint256[](by.length);
        for (uint256 i = 0; i < by.length; i++) {
            template[i] = id(by[i]);
        }

        // Third line onwards are the rules
        for (uint256 i = 2; i < lines.length; i++) {
            by = bytes(lines[i]);
            // First two characters are the keys, last character is the value.
            uint256 e1 = id(by[0]);
            uint256 e2 = id(by[1]);
            uint256 ev = id(by[by.length - 1]);
            rules[ruleKey(e1, e2)] = ev;
        }
    }

    function id(bytes1 s) private returns (uint256 r) {
        r = knownIds[s];
        if (r == 0) {
            knownIds[s] = ++nextId;
            r = nextId;
        }
    }

    /// The individual elements are all characters, so we know that there'll be
    /// a max 26 of them.
    function ruleKey(uint256 e1, uint256 e2) private pure returns (uint256) {
        return e1 * 100 + e2;
    }

    function rule(uint256 e1, uint256 e2) internal view returns (uint256) {
        return rules[ruleKey(e1, e2)];
    }

    function maxId() internal view returns (uint256) {
        return nextId;
    }
}

contract _14 is _14Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[] memory template = parse(input);
        return (p1(template), 0);
    }

    function p1(uint256[] memory template) private returns (uint256) {
        return diff(sim(template, 0));
    }

    // We cannot resize in memory arrays, so use this as a scratch pad.
    uint256[] private next;

    function step(uint256[] memory t) private returns (uint256[] memory) {
        delete next;
        uint256 residue;
        for (uint256 i = 0; i < t.length - 1; i++) {
            next.push(t[i]);
            uint256 v = rule(t[i], t[i + 1]);
            if (v > 0) {
                next.push(v);
                residue = t[i + 1];
            } else {
                next.push(t[i + 1]);
                residue = 0;
            }
        }
        if (residue > 0) next.push(residue);
        return next;
    }

    function sim(uint256[] memory template, uint256 steps)
        private
        returns (uint256[] memory polymer)
    {
        polymer = template;
        for (; steps > 0; steps--) polymer = step(polymer);
    }

    function diff(uint256[] memory polymer) private view returns (uint256) {
        uint256[] memory counts = new uint256[](maxId() + 1);
        uint256 min = type(uint256).max;
        uint256 max = 0;
        for (uint256 i = 0; i < polymer.length; i++) {
            uint256 c = ++counts[polymer[i]];
            if (c < min) min = c;
            if (c > max) max = c;
        }
        return max - min;
    }
}

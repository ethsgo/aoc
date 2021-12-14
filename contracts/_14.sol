// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "hardhat/console.sol";

contract _13Parser is Parser {
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

    mapping(bytes1 => uint256) knownIds;
    uint256 nextId;
    mapping(uint256 => uint256) rules;

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

    function rule(uint256 e1, uint256 e2) private view returns (uint256) {
        return rules[ruleKey(e1, e2)];
    }
}

contract _13 is _13Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[] memory template = parse(input);
        return (p1(template), 0);
    }

    function p1(uint256[] memory template) private pure returns (uint256) {
        return 0;
    }

    function minMax(uint256[] memory xs)
        private
        pure
        returns (uint256 min, uint256 max)
    {
        min = xs[0];
        max = xs[0];
        for (uint256 i = 1; i < xs.length; i++) {
            if (xs[i] < min) min = xs[i];
            if (xs[i] > max) max = xs[i];
        }
    }
}

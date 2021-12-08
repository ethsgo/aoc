// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _08Parser is Parser {
    string private constant exampleInput =
        "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | "
        "fdgacbe cefdb cefbgd gcbe "
        "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | "
        "fcgedb cgb dgebacf gc "
        "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | "
        "cg cg fdcagb cbg "
        "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | "
        "efabcd cedba gadfec cb "
        "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | "
        "gecf egdcabf bgf bfgea "
        "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | "
        "gebdcfa ecba ca fadegcb "
        "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | "
        "cefg dcbef fcge gbcadfe "
        "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | "
        "ed bcgafe cdgba cbgef "
        "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | "
        "gbdfcae bgc cg cgb "
        "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | "
        "fgae cfgab fg bagce ";

    struct Entry {
        string[10] patterns;
        string[4] digits;
    }

    function parse(string memory input) internal returns (Entry[] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);

        Entry[] memory entries = new Entry[](tokens.length / 14);
        for (uint256 i = 0; i < tokens.length; i += 14) {
            string[10] memory patterns;
            string[4] memory digits;
            for (uint256 j = 0; j < 10; j++) {
                patterns[j] = tokens[i + j];
            }
            for (uint256 j = 0; j < 4; j++) {
                digits[j] = tokens[i + 10 + j];
            }
            entries[i / 14] = Entry({patterns: patterns, digits: digits});
        }
        return entries;
    }
}

contract _08 is _08Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        Entry[] memory entries = parse(input);
        return (p2(entries), 0);
    }

    function p1(Entry[] memory entries) private pure returns (uint256) {
        uint256 c = 0;
        for (uint256 i = 0; i < entries.length; i++) {
            string[4] memory digits = entries[i].digits;
            for (uint256 j = 0; j < digits.length; j++) {
                uint256 len = bytes(digits[j]).length;
                if (len == 2) c++; // 1
                if (len == 3) c++; // 7
                if (len == 4) c++; // 4
                if (len == 7) c++; // 8
            }
        }
        return c;
    }

    function p2(Entry[] memory entries) private pure returns (uint256) {
        return value(entries[0]);
    }

    function value(Entry memory entry) private pure returns (uint256) {
        return segments(entry.digits[0]);
    }

    /// Return a bitmap where each bit represents which of a b c d e f g were on.
    function segments(string memory pattern) private pure returns (uint8) {
        bytes memory b = bytes(pattern);
        uint8 result;
        for (uint256 i = 0; i < b.length; i++) {
            result |= uint8(1 << (uint8(b[i]) - ascii_a));
        }
        return result;
    }
}

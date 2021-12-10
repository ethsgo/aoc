// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./ArrayUtils.sol";

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

    string exampleInputShort =
        "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | "
        "cdfeb fcadb cdfeb cdbaf";

    struct Entry {
        string[10] patterns;
        string[4] digits;
    }

    function parse(string memory input) internal returns (Entry[] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);

        Entry[] memory entries = new Entry[](tokens.length / 15);
        for (uint256 i = 0; i < tokens.length; i += 15) {
            string[10] memory patterns;
            string[4] memory digits;
            for (uint256 j = 0; j < 10; j++) {
                patterns[j] = tokens[i + j];
            }
            // skip '|'
            for (uint256 j = 0; j < 4; j++) {
                digits[j] = tokens[i + 11 + j];
            }
            entries[i / 15] = Entry({patterns: patterns, digits: digits});
        }
        return entries;
    }
}

contract _08 is _08Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        Entry[] memory entries = parse(input);
        return (p1(entries), p2(entries));
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
        return sum(mapEntries(entries, value));
    }

    function mapEntries(
        Entry[] memory entries,
        function(Entry memory) internal pure returns (uint256) f
    ) private pure returns (uint256[] memory) {
        uint256[] memory result = new uint256[](entries.length);
        for (uint256 i = 0; i < entries.length; i++) result[i] = f(entries[i]);
        return result;
    }

    function value(Entry memory entry) private pure returns (uint256) {
        uint8[10] memory segments = deduceSegments(entry.patterns);
        uint256 result;
        for (uint256 i = 0; i < entry.digits.length; i++) {
            result *= 10;
            result += digitValue(segments, entry.digits[i]);
        }
        return result;
    }

    function digitValue(uint8[10] memory segments, string memory digit)
        private
        pure
        returns (uint256)
    {
        uint8 s = segment(digit);
        for (uint256 i = 0; i < segments.length; i++) {
            if (s == segments[i]) return i;
        }
        revert();
    }

    /// Deduce the segments representing each digit (indexed by the digit).
    function deduceSegments(string[10] memory patterns)
        private
        pure
        returns (uint8[10] memory)
    {
        uint8[10] memory sx;

        // Candidates for 5 and 6 segment digits
        uint8[3] memory c5;
        uint8[3] memory c6;
        uint8 c5i;
        uint8 c6i;

        for (uint256 i = 0; i < patterns.length; i++) {
            uint256 len = bytes(patterns[i]).length;
            uint8 s = segment(patterns[i]);
            if (len == 2) sx[1] = s;
            if (len == 3) sx[7] = s;
            if (len == 4) sx[4] = s;
            if (len == 7) sx[8] = s;
            if (len == 5) c5[c5i++] = s;
            if (len == 6) c6[c6i++] = s;
        }

        // Find the three horizontal segments by taking the segments that are
        // common in all 5 digit candidates.
        uint8 h = c5[0] & c5[1] & c5[2];

        // Segments for 3 are the horizontal segments and the right vertical
        // segments, which we can get from the segments for digit 1.
        sx[3] = h | sx[1];

        // If we remove the segments of digit 3 from the segments of digit 4,
        // then what is left is the top left vertical segment.
        uint8 tlv = sx[4] & (~sx[3]);

        // Of the two remaining 5 segment candidate, the one which has this top
        // left vertical segment set is digit 5, and the other one is digit 2.
        for (uint256 i = 0; i < 3; i++) {
            if (c5[i] == sx[3]) continue;
            sx[(c5[i] & tlv == tlv) ? 5 : 2] = c5[i];
        }

        // Adding the right vertical segments to 5 gives us the segments for 9.
        sx[9] = sx[5] | sx[1];

        // Of the two remaining 6 segment candidates, digit 6 has all three of the
        // horizontal segments set. The remaining one is digit 0.
        for (uint256 i = 0; i < 3; i++) {
            if (c6[i] == sx[9]) continue;
            sx[(c6[i] & h == h) ? 6 : 0] = c6[i];
        }

        return sx;
    }

    /// Return a bitmap where each bit represents which of a b c d e f g were on.
    function segment(string memory pattern) private pure returns (uint8) {
        bytes memory b = bytes(pattern);
        uint8 result;
        for (uint256 i = 0; i < b.length; i++) {
            result |= uint8(1 << (uint8(b[i]) - ascii_a));
        }
        return result;
    }

    function toString(uint8 s) private pure returns (string memory) {
        return
            string(
                bytes.concat(
                    bytes((s & (1 << 0) == 0) ? "-" : "a"),
                    bytes((s & (1 << 1) == 0) ? "-" : "b"),
                    bytes((s & (1 << 2) == 0) ? "-" : "c"),
                    bytes((s & (1 << 3) == 0) ? "-" : "d"),
                    bytes((s & (1 << 4) == 0) ? "-" : "e"),
                    bytes((s & (1 << 5) == 0) ? "-" : "f"),
                    bytes((s & (1 << 6) == 0) ? "-" : "g")
                )
            );
    }
}

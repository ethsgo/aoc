// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _10Parser is Parser {
    string private constant exampleInput =
        "[({(<(())[]>[[{[]{<()<>> "
        "[(()[<>])]({[<{<<[]>>( "
        "{([(<{}[<>[]}>{[]{[(<()> "
        "(((({<>}<{<{<>}{[]{[]{} "
        "[[<[([]))<([[{}[[()]]] "
        "[{[{({}]{}}([{[{{{}}([] "
        "{<[[]]>}<{[{[{[]{()[[[] "
        "[<(<(<(<{}))><([]([]() "
        "<{([([[(<>()){}]>(<<{{ "
        "<{([{{}}[<[[[<>{}]]]>[]] ";

    function parse(string memory input)
        internal
        returns (string[] memory lines)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;
        lines = parseTokens(s);
    }
}

contract _10 is _10Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory lines = parse(input);
        return (p1(lines), p2(lines));
    }

    function p1(string[] memory lines) private returns (uint256 score) {
        for (uint256 i = 0; i < lines.length; i++) {
            score += matchChunks(lines[i]);
        }
    }

    function p2(string[] memory lines) private returns (uint256) {
        delete scores;
        for (uint256 i = 0; i < lines.length; i++) {
            uint256 s = autocompleteScore(lines[i]);
            if (s > 0) scores.push(s);
        }
        return medianScore();
    }

    /// Return a non-zero score if s was corrupted. On exit the stack contains
    /// the unmatched characters that represent incomplete chunks.
    function matchChunks(string memory s) private returns (uint256) {
        delete stack;
        bytes memory b = bytes(s);
        for (uint256 i = 0; i < b.length; i++) {
            bytes1 c = b[i];
            if (c == ")") {
                if (pop() == "(") continue;
                else return 3;
            }
            if (c == "]") {
                if (pop() == "[") continue;
                else return 57;
            }
            if (c == "}") {
                if (pop() == "{") continue;
                else return 1197;
            }
            if (c == ">") {
                if (pop() == "<") continue;
                else return 25137;
            }
            stack.push(c);
        }
        return 0;
    }

    function pop() private returns (bytes1 top) {
        top = stack[stack.length - 1];
        stack.pop();
    }

    function autocompleteScore(string memory s) private returns (uint256 t) {
        if (matchChunks(s) > 0) return 0;

        while (stack.length > 0) {
            bytes1 c = pop();
            t *= 5;
            if (c == "(") t += 1;
            if (c == "[") t += 2;
            if (c == "{") t += 3;
            if (c == "<") t += 4;
        }
    }

    /// Find the median score by doing a selection sort.
    function medianScore() private returns (uint256) {
        // alias
        uint256[] storage xs = scores;
        uint256 n = xs.length;
        // We know that the number of scores is odd.
        uint256 k = n / 2;
        for (uint256 i = 0; i <= k; i++) {
            for (uint256 j = i + 1; j < n; j++) {
                if (xs[j] < xs[i]) {
                    uint256 t = xs[i];
                    xs[i] = xs[j];
                    xs[j] = t;
                }
            }
        }
        return xs[k];
    }

    // Dynamic memory arrays cannot be resized, so store these.
    bytes1[] private stack;
    uint256[] private scores;
}

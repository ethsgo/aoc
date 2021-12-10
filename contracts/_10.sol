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
        return (p1(lines), 0);
    }

    function p1(string[] memory lines) private returns (uint256 score) {
        for (uint256 i = 0; i < lines.length; i++) {
            score += p1line(lines[i]);
        }
    }

    function p1line(string memory s) private returns (uint256 score) {
        delete stack;
        bytes memory b = bytes(s);
        for (uint256 i = 0; i < b.length; i++) {
            bytes1 c = b[i];
            if (c == b_a1 && pop() != b_a0) return 3;
            if (c == b_b1 && pop() != b_b0) return 57;
            if (c == b_c1 && pop() != b_c0) return 1197;
            if (c == b_d1 && pop() != b_d0) return 25137;
            stack.push(c);
        }
    }

    function pop() private returns (bytes1 top) {
        top = stack[stack.length - 1];
        stack.pop();
    }

    // Dynamic memory arrays cannot be resized, so store this.
    bytes1[] private stack;

    /// ASCII bytes for (), [], {} and <>
    bytes1 private constant b_a0 = bytes1(uint8(40));
    bytes1 private constant b_a1 = bytes1(uint8(41));
    bytes1 private constant b_b0 = bytes1(uint8(91));
    bytes1 private constant b_b1 = bytes1(uint8(93));
    bytes1 private constant b_c0 = bytes1(uint8(123));
    bytes1 private constant b_c1 = bytes1(uint8(125));
    bytes1 private constant b_d0 = bytes1(uint8(60));
    bytes1 private constant b_d1 = bytes1(uint8(62));
}

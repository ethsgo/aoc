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

    function p1(string[] memory lines) private pure returns (uint256 score) {
        for (uint256 i = 0; i < lines.length; i++) {
            score += p1line(lines[i]);
        }
    }

    function p1line(string memory s) private pure returns (uint256 score) {}
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _18Parser is Parser {
    string private constant exampleInput =
        "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]\n"
        "[[[5,[2,8]],4],[5,[[9,9],0]]]\n"
        "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]\n"
        "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]\n"
        "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]\n"
        "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]\n"
        "[[[[5,4],[7,7]],8],[[8,3],8]]\n"
        "[[9,3],[[9,9],[6,[4,9]]]]\n"
        "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]\n"
        "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]\n";

    function parse(string memory input)
        internal
        returns (uint256[2][][] memory xss)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n");
        xss = new uint256[2][][](lines.length);
        for (uint256 i = 0; i < lines.length; i++) {
            xss[i] = parseNum(lines[i]);
        }
    }

    function parseNum(string memory s)
        private
        pure
        returns (uint256[2][] memory xs)
    {
        bytes memory bs = bytes(s);
        // count commas to find out how many entries we'll need.
        uint256 cc;
        for (uint256 i = 0; i < bs.length; i++) if (bs[i] == ",") cc++;
        xs = new uint256[2][](cc + 1);
        cc = 0;
        uint256 depth = 0;
        for (uint256 i = 0; i < bs.length; i++) {
            if (bs[i] == "[") {
                depth++;
            } else if (bs[i] == "]") {
                depth--;
            } else if (bs[i] != ",") {
                xs[cc++] = [parseDigit(bs[i]), depth];
            }
        }
    }
}

contract _18 is _18Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[2][][] memory xss = parse(input);
        return (p1(xss), 0);
    }

    function p1(uint256[2][][] memory xss) private pure returns (uint256) {
        return xss.length;
    }
}

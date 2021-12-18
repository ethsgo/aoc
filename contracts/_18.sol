// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./StringUtils.sol";
import "hardhat/console.sol";

contract _18Parser is Parser {
    string private constant exampleInput =
        "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]\n"
        "[[[[4,3],4],4],[7,[[8,4],9]]]\n"
        "[1,1]\n"
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

contract _18ArrayUtils is StringUtils {
    function print(uint256[2][] memory xs) internal view {
        bytes memory bs;
        for (uint256 i = 0; i < xs.length; i++) {
            bs = bytes.concat(
                bs,
                bytes(bs.length > 0 ? " " : ""),
                bytes(uintString(xs[i][0])),
                bytes("/"),
                bytes(uintString(xs[i][1]))
            );
        }
        console.log(string(bs));
    }

    function remove(uint256[2][] memory xs, uint256 i)
        internal
        pure
        returns (uint256[2][] memory ys)
    {
        ys = new uint256[2][](xs.length - 1);
        for (uint256 j = 0; j < i; j++) ys[j] = xs[j];
        for (; i < xs.length - 1; i++) ys[i] = xs[i + 1];
    }

    function insert(
        uint256[2][] memory xs,
        uint256 i,
        uint256[2] memory x
    ) internal pure returns (uint256[2][] memory ys) {
        ys = new uint256[2][](xs.length + 1);
        for (uint256 j = 0; j <= i; j++) ys[j] = xs[j];
        ys[i] = x;
        for (; i < xs.length; i++) ys[i + 1] = xs[i];
    }
}

contract _18 is _18Parser, _18ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[2][][] memory xss = parse(input);
        return (p1(xss), 0);
    }

    function p1(uint256[2][][] memory xss) private view returns (uint256) {
        print(xss[0]);
        uint256[2][] memory ys = reduce(xss[0]);
        print(ys);

        return xss.length;
    }

    function reduce(uint256[2][] memory xs)
        private
        pure
        returns (uint256[2][] memory)
    {
        while (true) {
            (uint256[2][] memory ys, bool didExplode) = explode(xs);
            if (didExplode) {
                xs = ys;
            } else {
                (uint256[2][] memory zs, bool didSplit) = split(xs);
                if (didSplit) {
                    xs = zs;
                } else {
                    return xs;
                }
            }
        }
        revert();
    }

    function explode(uint256[2][] memory xs)
        private
        pure
        returns (uint256[2][] memory ys, bool didExplode)
    {
        for (uint256 i = 0; i < xs.length; i++) {
            if (xs[i][1] == 5) {
                uint256 xl = xs[i][0];
                uint256 xr = xs[i + 1][0];
                ys = remove(xs, i + 1);
                ys[i] = [uint256(0), 4];
                if (i > 0) ys[i - 1][0] += xl;
                if (i + 1 < ys.length) ys[i + 1][0] += xr;
                return (ys, true);
            }
        }
    }

    function split(uint256[2][] memory xs)
        private
        pure
        returns (uint256[2][] memory ys, bool didSplit)
    {
        for (uint256 i = 0; i < xs.length; i++) {
            if (xs[i][0] >= 10) {
                uint256 depth = xs[i][1];
                uint256 xl = xs[i][0] / 2;
                uint256 xr = (xs[i][0] + 1) / 2;
                ys = insert(xs, i + 1, [xr, depth + 1]);
                ys[i] = [xl, depth + 1];
                return (ys, true);
            }
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./StringUtils.sol";
import "hardhat/console.sol";

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

    struct Node {
        // Valid when children.length == 0
        uint256 value;
        // We just have two children, left and right, but we need to use an
        // array to get around the limitation of not being able to define
        // recursive structs.
        Node[] children;
    }

    function parse(string memory input) internal returns (Node[] memory xss) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n");
        xss = new Node[](1); //lines.length);
        // for (uint256 i = 0; i < lines.length; i++) {
        //     xss[i] = parseNum(lines[i]);
        // }

        xss[0] = parseNum(lines[0]);
    }

    function parseNum(string memory s) private returns (Node memory) {
        console.log(s);
        (Node memory xs, ) = parseNum(bytes(s), 0);
        return xs;
    }

    function parseNum(bytes memory bs, uint256 i)
        private
        returns (Node memory xs, uint256 j)
    {
        require(bs[i] == "[");
        j = i + 1;

        uint256 v;
        Node memory n1;
        if (bs[j] == "[") {
            // Nested pair
            (n1, j) = parseNum(bs, j);
        } else {
            // console.log(string(bytes.concat(bs[j])));
            v = parseDigit(bs[j]);
            j++;
        }

        if (bs[j] == "]") {
            // Regular number
            j++;
            xs.value = v;
        } else {
            // Pair
            n1 = Node({value: v, children: new Node[](0)});

            require(bs[j] == ",");
            j++;

            Node memory n2;
            if (bs[j] == "[") {
                // Nested pair
                (n2, j) = parseNum(bs, j);
            } else {
                v = parseDigit(bs[j]);
                j++;
                require(bs[j] == "]");
                j++;

                n2 = Node({value: v, children: new Node[](0)});
            }

            xs.children = new Node[](2);
            xs.children[0] = n1;
            xs.children[1] = n2;
        }
    }
}

contract _18ArrayUtils is StringUtils {
    function toString(uint256[2][] memory xs)
        internal
        pure
        returns (string memory)
    {
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
        return string(bs);
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
        for (uint256 j = 0; j < i; j++) ys[j] = xs[j];
        ys[i] = x;
        for (; i < xs.length; i++) ys[i + 1] = xs[i];
    }
}

contract _18Tree is _18Parser, _18ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        Node[] memory xss = parse(input);
        console.log(treeToString(xss[0]));
        return (xss.length, 0); //(p1(xss), p2(xss));
    }

    function p1(uint256[2][][] memory xss) private pure returns (uint256) {
        return magnitude(sum(xss));
    }

    function p2(uint256[2][][] memory xss) private pure returns (uint256 max) {
        for (uint256 i = 0; i < xss.length; i++) {
            for (uint256 j = 0; j < xss.length; j++) {
                if (i == j) continue;
                uint256 m = magnitude(add(xss[i], xss[j]));
                if (m > max) max = m;
            }
        }
    }

    function _treeToString(Node memory xs)
        internal
        pure
        returns (bytes memory)
    {
        if (xs.children.length == 0) {
            return bytes(uintString(xs.value));
        } else {
            return
                bytes.concat(
                    bytes("("),
                    _treeToString(xs.children[0]),
                    bytes(","),
                    _treeToString(xs.children[1]),
                    bytes(")")
                );
        }
    }

    function treeToString(Node memory xs)
        internal
        pure
        returns (string memory)
    {
        return string(_treeToString(xs));
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

    function magnitude(uint256[2][] memory xs) private pure returns (uint256) {
        uint256 i = 0;
        while (true) {
            uint256 v = xs[i][0];
            if (i + 1 < xs.length) {
                uint256 depth = xs[i][1];
                if (xs[i + 1][1] == depth) {
                    uint256 nv = xs[i + 1][0];
                    xs = remove(xs, i + 1);
                    xs[i] = [3 * v + 2 * nv, depth - 1];
                    i = 0;
                } else {
                    i++;
                }
            } else {
                return v;
            }
        }
        revert();
    }

    function join(uint256[2][] memory xs, uint256[2][] memory ys)
        private
        pure
        returns (uint256[2][] memory zs)
    {
        uint256 n = xs.length;
        zs = new uint256[2][](n + ys.length);
        for (uint256 i = 0; i < n; i++) zs[i] = [xs[i][0], xs[i][1] + 1];
        for (uint256 i = 0; i < ys.length; i++)
            zs[n + i] = [ys[i][0], ys[i][1] + 1];
    }

    function add(uint256[2][] memory xs, uint256[2][] memory ys)
        private
        pure
        returns (uint256[2][] memory zs)
    {
        zs = join(xs, ys);
        zs = reduce(zs);
    }

    function sum(uint256[2][][] memory xss)
        private
        pure
        returns (uint256[2][] memory xs)
    {
        xs = xss[0];
        for (uint256 i = 1; i < xss.length; i++) xs = add(xs, xss[i]);
    }
}

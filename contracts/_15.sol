// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _15Parser is Parser {
    string private constant exampleInput =
        "1163751742\n"
        "1381373672\n"
        "2136511328\n"
        "3694931569\n"
        "7463417111\n"
        "1319128137\n"
        "1359912421\n"
        "3125421639\n"
        "1293138521\n"
        "2311944581\n";

    function parse(string memory input)
        internal
        returns (uint256[][] memory g)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);

        g = new uint256[][](lines.length);
        for (uint256 i = 0; i < lines.length; i++) {
            bytes memory b = bytes(lines[i]);
            g[i] = new uint256[](b.length);
            for (uint256 j = 0; j < b.length; j++) {
                g[i][j] = parseDigit(b[j]);
            }
        }
    }
}

contract Heap {
    uint256[3][] internal heap;

    function lessThan(uint256 i, uint256 j) private view returns (bool) {
        return heap[i][2] < heap[j][2];
    }

    function equal(uint256[3] memory p, uint256[3] memory q)
        private
        pure
        returns (bool)
    {
        return p[0] == q[0] && p[1] == q[1];
    }

    function swap(uint256 i, uint256 j) private {
        uint256[3] memory t = heap[i];
        heap[i] = heap[j];
        heap[j] = t;
    }

    function lix(uint256 i) private pure returns (uint256) {
        return 2 * i + 1;
    }

    function rix(uint256 i) private pure returns (uint256) {
        return 2 * (i + 1);
    }

    function pix(uint256 i) private pure returns (uint256) {
        return (i - 1) / 2;
    }

    function heapPopMin() internal returns (uint256[3] memory r) {
        r = heap[0];
        uint256 i = 0;
        heap[0] = heap[heap.length - 1];
        heap.pop();
        while (i < heap.length) {
            uint256 li = lix(i);
            if (li >= heap.length) break;
            uint256 ri = rix(i);
            if (ri >= heap.length || lessThan(li, ri)) {
                if (lessThan(i, li)) break;
                swap(i, li);
                i = li;
            } else {
                if (lessThan(i, ri)) break;
                swap(i, ri);
                i = ri;
            }
        }
    }

    function heapInsertOrUpdate(uint256[3] memory e) internal {
        uint256 i = 0;
        while (i < heap.length) {
            if (equal(e, heap[i])) {
                heap[i] = e;
                break;
            }
            i++;
        }
        if (i == heap.length) heap.push(e);
        while (i > 0 && lessThan(i, pix(i))) {
            swap(i, pix(i));
            i = pix(i);
        }
    }
}

contract _15 is _15Parser, Heap {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[][] memory g = parse(input);
        return (p1(g), 0);
    }

    function p1(uint256[][] memory g) private returns (uint256) {
        return shortestPath(g);
    }

    mapping(uint256 => bool) visited;

    function visitKey(
        uint256[][] memory g,
        uint256 x,
        uint256 y
    ) private pure returns (uint256) {
        return g.length * y + x;
    }

    function shortestPath(uint256[][] memory g) private returns (uint256) {
        delete heap;

        uint256 ymax = g.length - 1;
        uint256 xmax = g[ymax].length - 1;

        uint256[3][] memory nx = neighbours(g, 0, 0, 0);
        for (uint256 i = 0; i < nx.length; i++) heapInsertOrUpdate(nx[i]);

        visited[visitKey(g, 0, 0)] = true;

        while (true) {
            uint256[3] memory m = heapPopMin();
            if (m[0] == xmax && m[1] == ymax) return m[2];

            nx = neighbours(g, m[0], m[1], m[2]);
            for (uint256 i = 0; i < nx.length; i++) {
                uint256 vk = visitKey(g, nx[i][0], nx[i][1]);
                if (!visited[vk]) {
                    heapInsertOrUpdate(nx[i]);
                    visited[vk] = true;
                }
            }
        }

        revert();
    }

    function neighbours(
        uint256[][] memory g,
        uint256 x,
        uint256 y,
        uint256 w
    ) private returns (uint256[3][] memory) {
        delete nStore;
        if (x > 0) nStore.push([x - 1, y, w + g[y][x - 1]]);
        if (x < g[y].length - 1) nStore.push([x + 1, y, w + g[y][x + 1]]);
        if (y > 0) nStore.push([x, y - 1, w + g[y - 1][x]]);
        if (y < g.length - 1) nStore.push([x, y + 1, w + g[y + 1][x]]);
        return nStore;
    }

    uint256[3][] private nStore;
}

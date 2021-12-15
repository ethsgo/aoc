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
    uint256 private lastIndex;

    function heapReset(uint256 maxSize) internal {
        delete heap;
        heap = new uint256[3][](maxSize);
    }

    function lessThan(uint256 i, uint256 j) private view returns (bool) {
        return heap[i][2] < heap[j][2];
    }

    function equal(uint256[3] memory p, uint256 j) private view returns (bool) {
        return p[0] == heap[j][0] && p[1] == heap[j][1];
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
        heap[0] = heap[lastIndex];
        lastIndex--;
        while (i <= lastIndex) {
            uint256 li = lix(i);
            if (li > lastIndex) break;
            uint256 ri = rix(i);
            if (ri > lastIndex || lessThan(li, ri)) {
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
        while (i <= lastIndex) {
            if (equal(e, i)) {
                heap[i] = e;
                break;
            }
            i++;
        }
        if (i > lastIndex) heap[++lastIndex] = e;
        while (i > 0 && lessThan(i, pix(i))) {
            swap(i, pix(i));
            i = pix(i);
        }
    }
}

contract _15 is _15Parser, Heap {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[][] memory g = parse(input);
        return (p1(g), p2(g));
    }

    function p1(uint256[][] memory g) private returns (uint256) {
        return shortestPath(g);
    }

    function p2(uint256[][] memory g) private returns (uint256) {
        return shortestPath(expand(g));
    }

    function expand(uint256[][] memory g)
        private
        pure
        returns (uint256[][] memory r)
    {
        uint256 nrow = g.length;
        uint256 ncol = g[0].length;
        r = new uint256[][](nrow * 5);
        for (uint256 y = 0; y < nrow; y++) {
            r[y] = new uint256[](ncol * 5);
            for (uint256 x = 0; x < ncol; x++) {
                r[y][x] = g[y][x];
                for (uint256 cm = 1; cm < 5; cm++) {
                    r[y][x * cm] = inc(r[y][x], cm);
                }
            }
        }
        for (uint256 rm = 1; rm < 5; rm++) {
            for (uint256 y = 0; y < nrow; y++) {
                r[nrow * rm + y] = new uint256[](ncol * 5);
                for (uint256 x = 0; x < ncol * 5; x++) {
                    r[nrow * rm + y][x] = inc(r[y][x], rm);
                }
            }
        }
    }

    function inc(uint256 w, uint256 i) private pure returns (uint256) {
        uint256 z = w + i;
        return z > 9 ? z % 9 : z;
    }

    function shortestPath(uint256[][] memory g) private returns (uint256) {
        uint256 ymax = g.length - 1;
        uint256 xmax = g[ymax].length - 1;
        uint256 vkm = g.length;

        heapReset(g.length * xmax);

        uint256 nend = neighbours(g, 0, 0, 0);
        for (uint256 i = 0; i < nend; i++) heapInsertOrUpdate(nx[i]);

        uint256[] memory visited = new uint256[]((ymax + 1) * (xmax + 1));
        visited[vkm * 0 + 0] = 1;

        while (true) {
            uint256[3] memory m = heapPopMin();
            if (m[0] == xmax && m[1] == ymax) return m[2];

            nend = neighbours(g, m[0], m[1], m[2]);
            for (uint256 i = 0; i < nend; i++) {
                uint256 vk = vkm * nx[i][0] + nx[i][1];
                if (visited[vk] == 0) {
                    heapInsertOrUpdate(nx[i]);
                    visited[vk] = 1;
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
    ) private returns (uint256 end) {
        end = 0;
        if (x > 0) nx[end++] = [x - 1, y, w + g[y][x - 1]];
        if (x < g[y].length - 1) nx[end++] = [x + 1, y, w + g[y][x + 1]];
        if (y > 0) nx[end++] = [x, y - 1, w + g[y - 1][x]];
        if (y < g.length - 1) nx[end++] = [x, y + 1, w + g[y + 1][x]];
    }

    uint256[3][4] private nx;
}

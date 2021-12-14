// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./ArrayUtils.sol";
import "hardhat/console.sol";

contract _12Parser is Parser {
    string private constant exampleInput =
        "start-A "
        "start-b "
        "A-c "
        "A-b "
        "b-d "
        "A-end "
        "b-end ";

    string private constant exampleInputM =
        "dc-end "
        "HN-start "
        "start-kj "
        "dc-start "
        "dc-HN "
        "LN-dc "
        "HN-end "
        "kj-sa "
        "kj-HN "
        "kj-dc ";

    uint256 internal constant startId = 0;
    uint256 internal constant endId = 1;

    function isSmallCave(uint256 id) internal pure returns (bool) {
        return id % 2 == 0 || id == endId;
    }

    function hasLowerCase(string memory s) private pure returns (bool) {
        bytes1 c = bytes(s)[0];
        return c >= "a" && c <= "z";
    }

    mapping(string => uint256) private seenIds;
    uint256 private nextIdSmall = 2;
    uint256 private nextIdLarge = 3;

    bytes32 private constant kstart = keccak256(abi.encodePacked("start"));
    bytes32 private constant kend = keccak256(abi.encodePacked("end"));

    function caveId(string memory s) private returns (uint256 id) {
        id = seenIds[s];
        if (id == 0) {
            bytes32 k = keccak256(abi.encodePacked(s));
            if (k == kstart) id = startId;
            else if (k == kend) id = endId;
            else {
                if (hasLowerCase(s)) {
                    id = nextIdSmall;
                    nextIdSmall += 2;
                } else {
                    id = nextIdLarge;
                    nextIdLarge += 2;
                }
            }
            console.log(s, id);
            seenIds[s] = id;
        }
    }

    function parse(string memory input)
        internal
        returns (uint256[2][] memory links)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);
        links = new uint256[2][](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            string[] memory uv = split(tokens[i], "-");
            links[i] = [caveId(uv[0]), caveId(uv[1])];
        }
    }
}

/// WIP - Does not work right now
/// https://old.reddit.com/r/adventofcode/comments/rehj2r/2021_day_12_solutions/ho8pbd6/
/// https://gist.github.com/zootos/148f1097027c66849b7bf1c02a711bf4
contract _12WIP is _12Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        compress(parse(input));
        return (p1(), p2());
    }

    function p1() private returns (uint256) {
        return pathCount(false);
    }

    function p2() private returns (uint256) {
        return pathCount(true);
    }

    mapping(uint256 => uint256[]) edges;
    mapping(uint256 => mapping(uint256 => uint256)) edges2;

    uint256[] private vertices;

    function compress(uint256[2][] memory uvs) private {
        // Because of the way the puzzle is structured, we know there are no
        // edges between two large caves (otherwise there would be infinite
        // loops).

        uint256[] memory keys = new uint256[](0);
        for (uint256 i = 0; i < uvs.length; i++) {
            uint256 u = uvs[i][0];
            uint256 v = uvs[i][1];

            if (v != 0) {
                edges[u].push(v);
            }

            if (u != 0) {
                edges[v].push(u);
            }

            keys = appendIfNew(keys, u);
            keys = appendIfNew(keys, v);
        }

        for (uint256 i = 0; i < keys.length; i++) {
            uint256 u = keys[i];
            if (!isSmallCave(u)) continue;
            vertices.push(u);

            uint256[] memory eu = edges[u];
            for (uint256 j = 0; j < eu.length; j++) {
                uint256 v = eu[j];
                if (!isSmallCave(v)) {
                    uint256[] memory ev = edges[v];
                    for (uint256 k = 0; k < ev.length; k++) {
                        uint256 w = ev[k];
                        edges2[u][w]++;
                    }
                } else {
                    edges2[u][v]++;
                }
            }
        }
    }

    function pathCount(bool allowOneSmallCave) private returns (uint256 p) {
        console.log("--");
        return dfs(startId, new uint256[](0), allowOneSmallCave);
    }

    function dfs(
        uint256 u,
        uint256[] memory visited,
        bool allowOneSmallCave
    ) private returns (uint256) {
        uint256 c = 0;
        visited = cloneAndAppend(visited, u);

        for (uint256 i = 0; i < vertices.length; i++) {
            uint256 v = vertices[i];
            if (u == v) continue;
            if (v == startId) continue;
            uint256 m = edges2[u][v];
            if (m == 0) continue;
            if (v == endId) {
                printPath(cloneAndAppend(visited, v), m);
                c += m;
                continue;
            }

            if (containsUint(visited, v)) {
                if (allowOneSmallCave) {
                    c += (m * dfs(v, visited, false));
                }
            } else {
                c += (m * dfs(v, visited, allowOneSmallCave));
            }
        }
        return c;
    }

    function printPath(uint256[] memory path, uint256 count) private view {
        return;
        bytes memory b;
        for (uint256 i = 0; i < path.length; i++) {
            b = bytes.concat(
                b,
                bytes1(uint8(bytes1("0")) + uint8(path[i])),
                " "
            );
        }
        console.log(count, string(b));
    }

    function cloneAndAppend(uint256[] memory xs, uint256 x)
        private
        pure
        returns (uint256[] memory copy)
    {
        uint256 n = xs.length;
        copy = new uint256[](n + 1);
        copy[n] = x;
        for (uint256 i = 0; i < n; i++) {
            copy[i] = xs[i];
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./ArrayUtils.sol";

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

    function isLargeCave(uint256 id) internal pure returns (bool) {
        return id % 2 == 1 && id != endId;
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

contract _12 is _12Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        compact(parse(input));
        return (p1(), p2());
    }

    function p1() private returns (uint256) {
        return pathCount(false);
    }

    function p2() private returns (uint256) {
        return pathCount(true);
    }

    mapping(uint256 => uint256[]) private edges;
    mapping(uint256 => mapping(uint256 => uint256)) private edgeCount;

    uint256[] private vertices;

    // Reduce the size of the graph by replacing all large caves by direct edges
    // between the small caves that connect via the cave (we know there are no
    // edges between two large caves otherwise there would be infinite
    // loops in the normal puzzle solution too).
    //
    // This can result in multiple edges between the same pair of small caves,
    // so we additionally keep count of the number of edges between two caves.
    //
    // Note that there can be valid self edges in this compacted graph.
    function compact(uint256[2][] memory links) private {
        uint256[] memory keys = new uint256[](0);

        for (uint256 i = 0; i < links.length; i++) {
            uint256 u = links[i][0];
            uint256 v = links[i][1];

            if (v != 0) edges[u].push(v);
            if (u != 0) edges[v].push(u);

            keys = appendIfNew(keys, u);
            keys = appendIfNew(keys, v);
        }

        for (uint256 i = 0; i < keys.length; i++) {
            uint256 u = keys[i];

            if (isLargeCave(u)) continue;

            vertices.push(u);

            uint256[] memory eu = edges[u];
            for (uint256 j = 0; j < eu.length; j++) {
                uint256 v = eu[j];
                if (isLargeCave(v)) {
                    uint256[] memory ev = edges[v];
                    for (uint256 k = 0; k < ev.length; k++) {
                        uint256 w = ev[k];
                        edgeCount[u][w]++;
                    }
                } else {
                    edgeCount[u][v]++;
                }
            }
        }
    }

    function pathCount(bool skipOnce) private returns (uint256 p) {
        delete visited;
        visited = new uint256[](vertices.length * 2);
        return dfs(startId, 0, skipOnce);
    }

    uint256[] private visited;

    function dfs(
        uint256 u,
        uint256 iv,
        bool skipOnce
    ) private returns (uint256 c) {
        visited[iv] = u;
        for (uint256 i = 0; i < vertices.length; i++) {
            uint256 v = vertices[i];
            if (v == startId) continue;
            uint256 m = edgeCount[u][v];
            if (m == 0) continue;

            if (v == endId) {
                c += m;
                continue;
            }

            if (containsUintUpto(visited, iv, v)) {
                if (skipOnce) {
                    c += (m * dfs(v, iv + 1, false));
                }
            } else {
                c += (m * dfs(v, iv + 1, skipOnce));
            }
        }
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

    function containsUintUpto(
        uint256[] memory xs,
        uint256 maxI,
        uint256 x
    ) internal pure returns (bool) {
        for (uint256 i = 0; i <= maxI; i++) {
            if (xs[i] == x) return true;
        }
        return false;
    }
}

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
            string[] memory uv = split(tokens[i], "-", 0);
            links[i] = [caveId(uv[0]), caveId(uv[1])];
        }
    }
}

contract _12 is _12Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        compress(parse(input));
        return (p1(), p2());
    }

    struct Link {
        uint256 a;
        uint256 b;
    }

    Link[] private links;

    mapping(uint256 => uint256) linkCount;

    /// Workaround since we cannot use the Link struct as a mapping key.
    function linkId(Link memory link) private pure returns (uint256) {
        return link.a * 1000 + link.b;
    }

    function compress(uint256[2][] memory uvs) private {
        for (uint256 i = 0; i < uvs.length; i++) {
            uint256 u = uvs[i][0];
            uint256 v = uvs[i][1];
            if (v < u) {
                v = uvs[i][0];
                u = uvs[i][1];
            }
            Link memory link = Link(u, v);
            links.push(link);
            linkCount[linkId(link)]++;
        }

        // Because of the way the puzzle is structured, we know there are no
        // edges between two large caves (otherwise there would be infinite loops).
    }

    struct Route {
        uint256 u;
        uint256[] visited;
        bool canSkip;
    }

    Route[] private frontier;

    function pathCount(bool allowOneSmallCave) private returns (uint256 p) {
        delete frontier;

        frontier.push(
            Route({
                u: startId,
                visited: new uint256[](0),
                canSkip: allowOneSmallCave
            })
        );

        while (frontier.length > 0) {
            Route memory route = frontier[frontier.length - 1];
            frontier.pop();

            uint256[] memory visited = cloneVisited(
                route.visited,
                isSmallCave(route.u) ? route.u : 0
            );

            for (uint256 i = 0; i < links.length; i++) {
                (uint256 v, bool exists) = nextEdge(links[i], route.u);
                if (!exists) continue;
                if (v == startId) {
                    continue;
                }
                if (v == endId) {
                    p++;
                    continue;
                }
                if (containsUint(visited, v)) {
                    if (route.canSkip) {
                        frontier.push(
                            Route({u: v, visited: visited, canSkip: false})
                        );
                    }
                } else {
                    frontier.push(
                        Route({u: v, visited: visited, canSkip: route.canSkip})
                    );
                }
            }
        }
    }

    function cloneVisited(uint256[] memory visited, uint256 optionalSuffix)
        private
        pure
        returns (uint256[] memory copy)
    {
        uint256 n = visited.length;
        if (optionalSuffix == 0) {
            copy = new uint256[](n);
        } else {
            copy = new uint256[](n + 1);
            copy[n] = optionalSuffix;
        }
        for (uint256 i = 0; i < n; i++) {
            copy[i] = visited[i];
        }
    }

    function nextEdge(Link storage link, uint256 u)
        private
        view
        returns (uint256, bool)
    {
        if (link.a == u) return (link.b, true);
        if (link.b == u) return (link.a, true);
        return (0, false);
    }

    function p1() private returns (uint256) {
        return pathCount(false);
    }

    function p2() private returns (uint256) {
        return pathCount(true);
    }
}

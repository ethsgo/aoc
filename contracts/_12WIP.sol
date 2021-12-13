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
        string memory s = bytes(input).length == 0 ? exampleInputM : input;

        string[] memory tokens = parseTokens(s);
        links = new uint256[2][](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            string[] memory uv = split(tokens[i], "-");
            links[i] = [caveId(uv[0]), caveId(uv[1])];
        }
    }
}

/// WIP - Does not work right now
/// Try to compress the graph by combining all edges that go via a large cave.
/// References:
/// - https://old.reddit.com/r/adventofcode/comments/rehj2r/2021_day_12_solutions/ho8pbd6/
/// - https://www.reddit.com/r/adventofcode/comments/rehj2r/2021_day_12_solutions/ho7ojrt/
///
/// - https://github.com/rogierhans/AOC/blob/master/AOC2/Day12DFS.cs
contract _12WIP is _12Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        compress(parse(input));
        return (p1(), p2());
    }

    struct Link {
        uint256 a;
        uint256 b;
        uint256 count;
    }

    Link[] private allLinks;
    Link[] private intermediateLinks;
    Link[] private links;

    mapping(uint256 => uint256) linkCount;

    /// Workaround since we cannot use the Link struct as a mapping key.
    function linkId(Link memory link) private pure returns (uint256) {
        return linkId(link.a, link.b);
    }

    function linkId(uint256 a, uint256 b) private pure returns (uint256) {
        if (a < b) {
            return a * 1000 + b;
        } else {
            return b * 1000 + a;
        }
    }

    function compress(uint256[2][] memory uvs) private {
        // Because of the way the puzzle is structured, we know there are no
        // edges between two large caves (otherwise there would be infinite loops).
        for (uint256 i = 0; i < uvs.length; i++) {
            uint256 u = uvs[i][0];
            uint256 v = uvs[i][1];
            if (isSmallCave(v)) {
                // Swap so that the large cave is always second.
                u = uvs[i][1];
                v = uvs[i][0];
            }
            Link memory link = Link(u, v, 0);
            allLinks.push(link);
            // linkCount[linkId(link)]++;
            // links.push(Link(u, v));
        }
        // return;

        console.log("all-links: --");
        for (uint256 i = 0; i < allLinks.length; i++) {
            uint256 u = allLinks[i].a;
            uint256 v = allLinks[i].b;
            console.log(u, v);
        }

        console.log("compressing: --");
        for (uint256 i = 0; i < allLinks.length; i++) {
            uint256 u = allLinks[i].a;
            uint256 v = allLinks[i].b;

            if (isSmallCave(v)) {
                // Both ends are small caves, continue.
                intermediateLinks.push(Link(u, v, 0));
                continue;
            }

            // Create a new edge representing a direct connection from u to all the
            // small caves that v is connected to.
            console.log("compress", u, v);
            for (uint256 j = i + 1; j < allLinks.length; j++) {
                if (allLinks[j].b != v) continue;
                uint256 w = allLinks[j].a;
                console.log("  adding", u, w);
                intermediateLinks.push(Link(u, w, 0));
            }
        }

        console.log("intermediate links: --");
        for (uint256 i = 0; i < intermediateLinks.length; i++) {
            uint256 u = intermediateLinks[i].a;
            uint256 v = intermediateLinks[i].b;
            if (u > v) {
                uint256 t = u;
                u = v;
                v = t;
                intermediateLinks[i].a = u;
                intermediateLinks[i].b = v;
            }
            console.log(u, v);
        }

        console.log("compressing inters: --");
        for (uint256 i = 0; i < intermediateLinks.length; i++) {
            uint256 u = intermediateLinks[i].a;
            uint256 v = intermediateLinks[i].b;
            if (linkCount[linkId(u, v)] > 0) continue;
            uint256 c = 1;
            for (uint256 j = i + 1; j < intermediateLinks.length; j++) {
                if (
                    u == intermediateLinks[j].a && v == intermediateLinks[j].b
                ) {
                    c++;
                }
            }
            linkCount[linkId(u, v)] = c;
            links.push(Link(u, v, c));
        }

        console.log("links: --");
        for (uint256 i = 0; i < links.length; i++) {
            uint256 u = links[i].a;
            uint256 v = links[i].b;
            uint256 c = links[i].count;
            console.log(u, v, c, linkCount[linkId(u, v)]);
        }
        console.log("--");
    }

    struct Route {
        uint256 u;
        uint256[] visited;
        uint256 multiplier;
        uint256 sum;
        uint256 c;
        bool canSkip;
    }

    Route[] private frontier;

    function pathCount(bool allowOneSmallCave) private returns (uint256 p) {
        return dfs(startId, new uint256[](0));
    }

    function dfs(uint256 u, uint256[] memory visited)
        private
        returns (uint256)
    {
        // if (u == endId) return 1;

        uint256 c = 0;
        uint256[] memory visitedU = cloneVisited(
            visited,
            isSmallCave(u) ? u : 0
        );
        for (uint256 i = 0; i < links.length; i++) {
            Link memory link = links[i];
            uint256 v = link.a == u ? link.b : link.b == u ? link.a : 0;
            if (v == startId) continue;
            uint256 m = linkCount[linkId(link)];
            if (u == endId) return m;
            if (containsUint(visited, v)) continue;

            console.log(u, v, ">", m);
            uint256 paths = dfs(v, visitedU);
            console.log(u, v, "<", paths);
            c += (paths * m);
        }
        return c;
    }

    function pathCount2(bool allowOneSmallCave) private returns (uint256 p) {
        console.log("---");
        // return 0;
        delete frontier;

        frontier.push(
            Route({
                u: startId,
                visited: new uint256[](0),
                multiplier: 1,
                sum: 0,
                c: 0,
                canSkip: allowOneSmallCave
            })
        );

        while (frontier.length > 0) {
            Route memory route = frontier[frontier.length - 1];
            frontier.pop();

            uint256 u = route.u;

            uint256[] memory visited = cloneVisited(
                route.visited,
                isSmallCave(u) ? u : 0
            );

            for (uint256 i = 0; i < links.length; i++) {
                (uint256 v, bool exists) = nextEdge(links[i], route.u);
                if (!exists) continue;
                if (v == startId) {
                    continue;
                }
                uint256 m = linkCount[linkId(u, v)] * route.multiplier;
                uint256 c = linkCount[linkId(u, v)] * (route.c + 1);
                console.log("edge", u, v, linkCount[linkId(u, v)]);
                if (v == endId) {
                    // console.log("p +=", (route.sum + 1) * m);
                    console.log("p +=", c);
                    p += c; //((route.sum + 1) * m);
                    continue;
                }
                if (containsUint(visited, v)) {
                    if (route.canSkip) {
                        frontier.push(
                            Route({
                                u: v,
                                visited: visited,
                                multiplier: m,
                                sum: 0,
                                c: c,
                                canSkip: false
                            })
                        );
                    }
                } else {
                    frontier.push(
                        Route({
                            u: v,
                            visited: visited,
                            multiplier: m,
                            sum: route.sum + m,
                            c: c,
                            canSkip: route.canSkip
                        })
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

    function p2() private pure returns (uint256) {
        return 0; //pathCount(true);
    }
}

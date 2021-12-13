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

    function parse(string memory input)
        internal
        returns (string[2][] memory links)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);
        links = new string[2][](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            string[] memory uv = split(tokens[i], "-");
            links[i] = [uv[0], uv[1]];
        }
    }
}

contract _12 is _12Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        string[2][] memory links = parse(input);
        return (p1(links), p2(links));
    }

    struct Route {
        string u;
        string[] visited;
        bool canSkip;
    }

    Route[] private frontier;

    bytes32 private constant kstart = keccak256(abi.encodePacked("start"));
    bytes32 private constant kend = keccak256(abi.encodePacked("end"));

    function pathCount(string[2][] memory links, bool allowOneSmallCave)
        private
        returns (uint256 p)
    {
        delete frontier;

        frontier.push(
            Route({
                u: "start",
                visited: new string[](0),
                canSkip: allowOneSmallCave
            })
        );

        while (frontier.length > 0) {
            Route memory route = frontier[frontier.length - 1];
            frontier.pop();

            string[] memory visited = cloneVisited(
                route.visited,
                hasLowerCase(route.u) ? route.u : ""
            );

            for (uint256 i = 0; i < links.length; i++) {
                string memory v = nextEdge(links[i], route.u);
                if (bytes(v).length == 0) continue;
                bytes32 kv = keccak256(abi.encodePacked(v));
                if (kv == kend) {
                    p++;
                    continue;
                }
                if (containsString(visited, v)) {
                    if (route.canSkip && kv != kstart) {
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

    function hasLowerCase(string memory s) private pure returns (bool) {
        bytes1 c = bytes(s)[0];
        return c >= "a" && c <= "z";
    }

    function cloneVisited(string[] memory strings, string memory optionalSuffix)
        private
        pure
        returns (string[] memory copy)
    {
        uint256 n = strings.length;
        if (bytes(optionalSuffix).length == 0) {
            copy = new string[](n);
        } else {
            copy = new string[](n + 1);
            copy[n] = optionalSuffix;
        }
        for (uint256 i = 0; i < n; i++) {
            copy[i] = strings[i];
        }
    }

    function nextEdge(string[2] memory link, string memory u)
        private
        pure
        returns (string memory)
    {
        bytes32 ku = keccak256(abi.encodePacked(u));
        if (keccak256(abi.encodePacked(link[0])) == ku) return link[1];
        if (keccak256(abi.encodePacked(link[1])) == ku) return link[0];
        return "";
    }

    function p1(string[2][] memory links) private returns (uint256) {
        return pathCount(links, false);
    }

    function p2(string[2][] memory links) private returns (uint256) {
        return pathCount(links, true);
    }
}

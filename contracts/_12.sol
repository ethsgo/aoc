// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _12Parser is Parser {
    string private constant exampleInput =
        "start-A "
        "start-b "
        "A-c "
        "A-b "
        "b-d "
        "A-end "
        "b-end ";

    function parse(string memory input)
        internal
        returns (string[2][] memory links)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory tokens = parseTokens(s);
        links = new string[2][](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            string[] memory uv = split(tokens[i], "-", 0);
            links[i] = [uv[0], uv[1]];
        }
    }
}

contract _12 is _12Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[2][] memory links = parse(input);
        return (p1(links), p2(links));
    }

    struct Route {
        string u;
        string[] visited;
        string[] path;
    }

    Route[] private frontier;

    function p1(string[2][] memory links) private returns (uint256 nPaths) {
        delete frontier;

        frontier.push(
            Route({u: "start", visited: new string[](0), path: new string[](0)})
        );

        while (frontier.length > 0) {
            Route memory route = frontier[frontier.length - 1];
            frontier.pop();

            string[] memory visited = cloneVisited(
                route.visited,
                hasLowerCase(route.u) ? route.u : ""
            );

            // string[][] memory paths =
        }

        nPaths = links.length;
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


    function p2(string[2][] memory links) private returns (uint256 nPaths) {}
}

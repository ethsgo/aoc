// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _02Parser is Parser {
    string internal constant exampleInput =
        "forward 5 down 5 forward 8 up 3 down 8 forward 2";

    /// Parse pairs of (delta-x, delta-y) values.
    ///
    /// Construct an array of (dx, dy) pairs from the given tokens.
    ///
    /// Directions are encoded as "forward", "up", "down". Since we're under
    /// water, "up" and "down" are reversed.
    function parseDxDy(string[] memory tokens)
        internal
        pure
        returns (int256[2][] memory)
    {
        require(tokens.length % 2 == 0, "parseDxDy expects pairs of tokens");

        int256[2][] memory dxdy = new int256[2][](tokens.length / 2);

        for (uint256 i = 0; i < tokens.length; i += 2) {
            int256 d = int256(parseUint(tokens[i + 1]));
            bytes32 tokenHash = keccak256(abi.encodePacked(tokens[i]));
            if (tokenHash == keccak256("forward")) {
                dxdy[i / 2] = [d, 0];
            } else if (tokenHash == keccak256("up")) {
                dxdy[i / 2] = [int32(0), -d];
            } else if (tokenHash == keccak256("down")) {
                dxdy[i / 2] = [int32(0), d];
            }
        }

        // Return a memory copy.
        return dxdy;
    }
}

contract _02 is _02Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory tokens = parseTokens(
            bytes(input).length == 0 ? exampleInput : input
        );

        int256[2][] memory dxdy = parseDxDy(tokens);

        return (p1(dxdy), p2(dxdy));
    }

    function p1(int256[2][] memory dxdy) private pure returns (uint256) {
        int256 x;
        int256 y;
        for (uint256 i = 0; i < dxdy.length; i++) {
            x += dxdy[i][0];
            y += dxdy[i][1];
        }
        return uint256(x * y);
    }

    function p2(int256[2][] memory dxdy) private pure returns (uint256) {
        int256 x;
        int256 y;
        int256 aim;
        for (uint256 i = 0; i < dxdy.length; i++) {
            aim += dxdy[i][1];
            x += dxdy[i][0];
            y += (dxdy[i][0] * aim);
        }
        return uint256(x * y);
    }
}

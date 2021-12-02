// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

/// Parse pairs of (delta-x, delta-y) values.
contract ParserDxDy is Parser {
    /// Dynamic array of pairs
    ///
    /// Only storage arrays have a .push function, so we need to keep the
    /// internal array used by the parse methods as a state variable.
    int256[2][] private dxdyStorage;

    /// Construct an array of (dx, dy) pairs from the given tokens.
    ///
    /// Directions are encoded as "forward", "up", "down". Since we're under
    /// water, "up" and "down" are reversed.
    function parseDxDy(string[] memory tokens)
        internal
        returns (int256[2][] memory)
    {
        require(tokens.length % 2 == 0, "parseDxDy expects pairs of tokens");

        // Clear the stored array, emptying it.
        delete dxdyStorage;
        // Get a local reference to the storage.
        int256[2][] storage dxdy = dxdyStorage;

        for (uint256 i = 0; i < tokens.length; i += 2) {
            int256 d = int256(parseUint(tokens[i + 1]));
            bytes32 tokenHash = keccak256(abi.encodePacked(tokens[i]));
            if (tokenHash == keccak256("forward")) {
                dxdy.push([d, 0]);
            } else if (tokenHash == keccak256("up")) {
                dxdy.push([int32(0), -d]);
            } else if (tokenHash == keccak256("down")) {
                dxdy.push([int32(0), d]);
            }
        }

        // Return a memory copy.
        return dxdy;
    }
}

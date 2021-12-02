// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

/// Parse pairs of (delta-x, delta-y) values.
contract ParserDxDy is Parser {
    /// Dynamic array of pairs
    ///
    /// Only storage arrays have a .push function, so we need to keep the
    /// internal array used by the parse methods as a state variable.
    uint256[2][] private dxdyStorage;

    /// Currently there doesn't seem to be a way of marking the enum private, we
    /// make do with the underscore prefix.
    enum _ParseDxDyState {
        expectingDirection,
        expectingValue
    }

    enum _Direction {
        invalid,
        forward,
        up,
        down
    }

    bytes private constant forward = bytes("forward");
    bytes private constant up = bytes("up");
    bytes private constant down = bytes("down");

    /// Parse the given string into an dynamic array of (dx, dy) pairs.
    ///
    /// Any non-lowercase, non-digit character acts as a separator.
    ///
    /// Directions are encoded as "forward", "up", "down". Since we're under
    /// water, "up" and "down" are reversed.
    function parseDxDy(string memory s) internal returns (uint256[2][] memory) {
        // Strings are not indexable.
        bytes memory b = bytes(s);

        // Clear the stored array, emptying it.
        delete dxdyStorage;
        // Get a local reference to the storage.
        uint256[2][] storage dxdy = dxdyStorage;

        uint256 i = 0;
        while (i < b.length) {
            // Look for direction.

            // Ignore everything until the first letter.
            uint8 ascii = uint8(b[i]);
            while (!(ascii >= ascii_a && ascii <= ascii_z)) {
                i++;
                if (i == b.length) break;
                ascii = uint8(b[i]);
            }
            if (i == b.length) break;

            // Luckily all three directions don't share any prefix so we can
            // just barge along the first match.
            uint256 j = 0;
            _Direction direction = _Direction.invalid;
        }
        uint256 x;
        uint256 y;
        _ParseDxDyState state = _ParseDxDyState.expectingDirection;

        // bool didSeeDigit = false;
        // for (uint256 i = 0; i < b.length; i++) {
        //     uint8 ascii = uint8(b[i]);
        //     if (ascii >= ascii0 && ascii <= ascii9) {
        //         uint256 digit = ascii - ascii0;
        //         x *= 10;
        //         x += digit;

        //         didSeeDigit = true;
        //     } else {
        //         if (didSeeDigit) {
        //             xs.push() = x;
        //         }
        //         x = 0;
        //         didSeeDigit = false;
        //     }
        // }

        // if (didSeeDigit) {
        //     xs.push() = x;
        // }

        // return xs;
        return dxdy;
    }
}

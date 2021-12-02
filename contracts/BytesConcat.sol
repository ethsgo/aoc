// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Demonstrate the need to use bytes.contact instead of uint8[] when
/// constructing strings from ASCII codepoints.
contract BytesConcat {
    function main() external pure {
        string memory s = parse("0");
        require(uint8(bytes(s)[0]) == 48);
    }

    function parse(string memory s) internal pure returns (string memory) {
        uint8 ascii = uint8(bytes(s)[0]);

        // Need to use bytes.contact instead of creating an array of
        // uint8 to ensure that the encoding is correct (otherwise the
        // string indexing stops working later on down the line).

        // This works
        return string(bytes.concat(bytes1(ascii)));

        // This doesn't
        // return string(abi.encodePacked([ascii]));
    }
}

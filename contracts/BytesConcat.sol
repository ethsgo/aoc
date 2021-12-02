// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Demonstrate the need to use bytes.contact instead of uint8[].push when
/// constructing strings from ASCII codepoints.
contract BytesConcat {
    function main() external {
        require(parseDigit(parseToken("0")) == 0);
    }

    bytes private tokenStorage;
    uint8[] private tokenStorageUint8;

    function parseToken(string memory s) internal returns (string memory) {
        bytes memory b = bytes(s);

        for (uint256 i = 0; i < b.length; i++) {
            uint8 ascii = uint8(b[i]);

            // Need to use bytes.contact instead of creating an array of
            // uint8 to ensure that the encoding is correct (otherwise the
            // string indexing stops working later on down the line).
            tokenStorage = bytes.concat(tokenStorage, bytes1(ascii));
            tokenStorageUint8.push(ascii);
        }

        return string(tokenStorage);
        // return string(abi.encodePacked(tokenStorageUint8));
    }

    function parseDigit(string memory s) internal pure returns (uint256) {
        uint8 ascii = uint8(bytes(s)[0]);
        return ascii - 48; // 48 == '0'
    }
}

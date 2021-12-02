// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _02 {
    //is Parser {
    /// Dynamic array of pairs
    uint256[2][] private _dxdy;

    // Returns a pointer to storage
    function parseDxDy(string calldata input)
        private
        returns (uint256[2][] storage)
    {
        delete _dxdy;
        _dxdy.push([uint256(1), 2]);
        return _dxdy;
    }

    function main(string calldata input) external returns (uint256, uint256) {
        /*
        uint256[] memory xs = parseInts(input);
        if (xs.length == 0) {
            xs = parseInts("forward 5 down 5 forward 8 up 3 down 8 forward 2");
        }
        return (p1(xs), p2(xs));
        */
        uint256[2][] storage dxdy = parseDxDy(input);
        return (dxdy.length, 0);
    }

    function p1(uint256[] memory xs) private pure returns (uint256) {
        uint256 increases;
        for (uint256 i = 1; i < xs.length; i++) {
            if (xs[i - 1] < xs[i]) {
                increases++;
            }
        }
        return increases;
    }

    function p2(uint256[] memory xs) private pure returns (uint256) {
        return 0;
    }
}

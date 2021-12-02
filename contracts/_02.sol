// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ParserDxDy.sol";

contract _02 is ParserDxDy {
    function main(string calldata input) external returns (uint256, uint256) {
        string[] memory tokens = parseTokens(input);
        if (tokens.length == 0) {
            tokens = parseTokens(
                "forward 5 down 5 forward 8 up 3 down 8 forward 2"
            );
        }

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

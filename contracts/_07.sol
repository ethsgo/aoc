// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _07Parser is Parser {
    string internal constant exampleInput = "16,1,2,0,4,2,7,1,2,14";

    function parse(string memory input) internal returns (uint256[] memory) {
        return parseUints(input);
    }
}

contract ArrayUtils {
    function min(uint256[] memory xs) internal pure returns (uint256) {}
}

contract _07 is _07Parser, ArrayUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        uint256[] memory crabs = parse(s);

        return (p1(crabs), p2(crabs));
    }

    function fuel(uint256[] memory crabs, uint256 position)
        private
        pure
        returns (uint256)
    {
        uint256 c = 0;
        for (uint256 i = 0; i < crabs.length; i++) {
            c += position < crabs[i]
                ? crabs[i] - position
                : position - crabs[i];
        }
        return c;
    }

    function minFuel(uint256[] memory crabs) private pure returns (uint256) {
        uint256 m = type(uint256).max;
        for (uint256 i = 0; i < crabs.length; i++) {
            uint256 f = fuel(crabs, crabs[i]);
            if (f < m) {
                m = f;
            }
        }
        return m;
    }

    function p1(uint256[] memory crabs) private pure returns (uint256) {
        return minFuel(crabs);
    }

    function p2(uint256[] memory crabs) private pure returns (uint256) {
        return 0;
    }
}

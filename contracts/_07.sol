// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _07Parser is Parser {
    string private constant exampleInput = "16,1,2,0,4,2,7,1,2,14";

    function parse(string memory input) internal returns (uint256[] memory) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        return parseUints(s);
    }
}

contract _07 is _07Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        uint256[] memory crabs = parse(input);
        return (p1(crabs), p2(crabs));
    }

    // Memoize fuel.
    mapping(uint256 => uint256) mfuel;

    function fuel(uint256[] memory crabs, uint256 position)
        private
        returns (uint256)
    {
        uint256 mf = mfuel[position];
        if (mf > 0) {
            return mf;
        }

        uint256 c = 0;
        for (uint256 i = 0; i < crabs.length; i++) {
            c += position < crabs[i]
                ? crabs[i] - position
                : position - crabs[i];
        }

        mfuel[position] = c;
        return c;
    }

    function p1(uint256[] memory crabs) private returns (uint256) {
        uint256 m = type(uint256).max;
        for (uint256 i = 0; i < crabs.length; i++) {
            uint256 f = fuel(crabs, crabs[i]);
            if (f < m) {
                m = f;
            }
        }
        return m;
    }

    function p2(uint256[] memory crabs) private pure returns (uint256) {
        return 0;
    }
}

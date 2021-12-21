// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";
import "./StringUtils.sol";
import "hardhat/console.sol";

contract _19Parser is Parser {
    string private constant exampleInput =
        "--- scanner 0 ---\n"
        "404,-588,-901\n"
        "528,-643,409\n"
        "-838,591,734\n"
        "390,-675,-793\n"
        "-537,-823,-458\n"
        "-485,-357,347\n"
        "-345,-311,381\n"
        "-661,-816,-575\n"
        "-876,649,763\n"
        "-618,-824,-621\n"
        "553,345,-567\n"
        "474,580,667\n"
        "-447,-329,318\n"
        "-584,868,-557\n"
        "544,-627,-890\n"
        "564,392,-477\n"
        "455,729,728\n"
        "-892,524,684\n"
        "-689,845,-530\n"
        "423,-701,434\n"
        "7,-33,-71\n"
        "630,319,-379\n"
        "443,580,662\n"
        "-789,900,-551\n"
        "459,-707,401\n"
        "\n"
        "--- scanner 1 ---\n"
        "686,422,578\n"
        "605,423,415\n"
        "515,917,-361\n"
        "-336,658,858\n"
        "95,138,22\n"
        "-476,619,847\n"
        "-340,-569,-846\n"
        "567,-361,727\n"
        "-460,603,-452\n"
        "669,-402,600\n"
        "729,430,532\n"
        "-500,-761,534\n"
        "-322,571,750\n"
        "-466,-666,-811\n"
        "-429,-592,574\n"
        "-355,545,-477\n"
        "703,-491,-529\n"
        "-328,-685,520\n"
        "413,935,-424\n"
        "-391,539,-444\n"
        "586,-435,557\n"
        "-364,-763,-893\n"
        "807,-499,-711\n"
        "755,-354,-619\n"
        "553,889,-390\n"
        "\n"
        "--- scanner 2 ---\n"
        "649,640,665\n"
        "682,-795,504\n"
        "-784,533,-524\n"
        "-644,584,-595\n"
        "-588,-843,648\n"
        "-30,6,44\n"
        "-674,560,763\n"
        "500,723,-460\n"
        "609,671,-379\n"
        "-555,-800,653\n"
        "-675,-892,-343\n"
        "697,-426,-610\n"
        "578,704,681\n"
        "493,664,-388\n"
        "-671,-858,530\n"
        "-667,343,800\n"
        "571,-461,-707\n"
        "-138,-166,112\n"
        "-889,563,-600\n"
        "646,-828,498\n"
        "640,759,510\n"
        "-630,509,768\n"
        "-681,-892,-333\n"
        "673,-379,-804\n"
        "-742,-814,-386\n"
        "577,-820,562\n"
        "\n"
        "--- scanner 3 ---\n"
        "-589,542,597\n"
        "605,-692,669\n"
        "-500,565,-823\n"
        "-660,373,557\n"
        "-458,-679,-417\n"
        "-488,449,543\n"
        "-626,468,-788\n"
        "338,-750,-386\n"
        "528,-832,-391\n"
        "562,-778,733\n"
        "-938,-730,414\n"
        "543,643,-506\n"
        "-524,371,-870\n"
        "407,773,750\n"
        "-104,29,83\n"
        "378,-903,-323\n"
        "-778,-728,485\n"
        "426,699,580\n"
        "-438,-605,-362\n"
        "-469,-447,-387\n"
        "509,732,623\n"
        "647,635,-688\n"
        "-868,-804,481\n"
        "614,-800,639\n"
        "595,780,-596\n"
        "\n"
        "--- scanner 4 ---\n"
        "727,592,562\n"
        "-293,-554,779\n"
        "441,611,-461\n"
        "-714,465,-776\n"
        "-743,427,-804\n"
        "-660,-479,-426\n"
        "832,-632,460\n"
        "927,-485,-438\n"
        "408,393,-506\n"
        "466,436,-512\n"
        "110,16,151\n"
        "-258,-428,682\n"
        "-393,719,612\n"
        "-211,-452,876\n"
        "808,-476,-593\n"
        "-575,615,604\n"
        "-485,667,467\n"
        "-680,325,-822\n"
        "-627,-443,-432\n"
        "872,-547,-609\n"
        "833,512,582\n"
        "807,604,487\n"
        "839,-516,451\n"
        "891,-625,532\n"
        "-652,-548,-490\n"
        "30,-46,-14\n";

    function parse(string memory input)
        internal
        returns (int256[3][][] memory scan)
    {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);
        // count the number of empty lines to determine the number of scanners
        // (in addition to the first scanner).
        uint256 scannerCount = 1;
        for (uint256 j = 1; j < lines.length; j++) {
            bytes memory bs = bytes(lines[j]);
            if (bs.length == 0) scannerCount++;
        }

        scan = new int256[3][][](scannerCount);

        uint256 i = 0;
        uint256 si = 0;
        while (i < lines.length) {
            // skip the "--- scanner x ---" line.
            i++;
            // read ahead to determine the size of the next array.
            uint256 beaconCount = 0;
            for (uint256 j = i; j < lines.length; j++) {
                if (bytes(lines[j]).length == 0) break;
                beaconCount++;
            }
            scan[si] = new int256[3][](beaconCount);
            for (uint256 j = 0; j < beaconCount; j++) {
                int256[] memory ints = parseInts(lines[i]);
                int256[3] memory beacon = [ints[0], ints[1], ints[2]];
                scan[si][j] = beacon;
                i++;
            }
            // skip the empty line
            i++;
            // subsequent data (if any) is part of the next scanner.
            si++;
        }
    }
}

contract _19 is _19Parser, StringUtils {
    function main(string calldata input) external returns (uint256, uint256) {
        int256[3][][] memory scan = parse(input);
        populatePermutations();
        return (permutations.length, 0);
        return (p1(scan), 0);
    }

    int256[3][] private permutations;

    struct Transform {
        int256[3] scannerPosition;
        uint256 permutationId;
    }

    function populatePermutations() private {
        for (int256 x = -2; x <= 2; x++) {
            for (int256 y = -2; y <= 2; y++) {
                if (y == x || y == -x) continue;
                for (int256 z = -2; z <= 2; z++) {
                    if (z == x || z == -x) continue;
                    if (z == y || z == -y) continue;
                    permutations.push([x, y, z]);
                    console.log(intString(x), intString(y), intString(z));
                }
            }
        }
    }

    function p1(int256[3][][] memory scan) private pure returns (uint256) {
        return scan.length;
    }
}

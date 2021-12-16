// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Parser.sol";

contract _16Parser is Parser {
    string private constant exampleInput = "8A004A801A8002F478";

    struct Packet {
        uint256 version;
        uint256 ptype;
        uint256 literal;
        Packet[] packets;
    }

    function parse(string memory input) internal returns (Packet memory p) {
        string memory s = bytes(input).length == 0 ? exampleInput : input;

        string[] memory lines = split(s, "\n", true);
        string memory line = lines[0];

        bytes memory bits = bytes(line);
        (p, ) = packet(bits, 0, bits.length * 4);
    }

    function bit(bytes memory bits, uint256 i) private pure returns (uint8) {
        bytes1 h = bits[i / 4];
        uint8[4] memory bin;
        if (h == "0") bin = [0, 0, 0, 0];
        if (h == "1") bin = [0, 0, 0, 1];
        if (h == "2") bin = [0, 0, 1, 0];
        if (h == "3") bin = [0, 0, 1, 1];
        if (h == "4") bin = [0, 1, 0, 0];
        if (h == "5") bin = [0, 1, 0, 1];
        if (h == "6") bin = [0, 1, 1, 0];
        if (h == "7") bin = [0, 1, 1, 1];
        if (h == "8") bin = [1, 0, 0, 0];
        if (h == "9") bin = [1, 0, 0, 1];
        if (h == "A") bin = [1, 0, 1, 0];
        if (h == "B") bin = [1, 0, 1, 1];
        if (h == "C") bin = [1, 1, 0, 0];
        if (h == "D") bin = [1, 1, 0, 1];
        if (h == "E") bin = [1, 1, 1, 0];
        if (h == "F") bin = [1, 1, 1, 1];
        return bin[i % 4];
    }

    function decimal(
        bytes memory bits,
        uint256 i,
        uint256 end
    ) private pure returns (uint256 d) {
        for (uint256 j = i; j < end; j++) {
            d *= 2;
            d += uint256(bit(bits, j));
        }
    }

    function packet(
        bytes memory bits,
        uint256 i,
        uint256 end
    ) private pure returns (Packet memory p, uint256 nexti) {
        uint256 v = decimal(bits, i, i += 3);
        uint256 t = decimal(bits, i, i += 3);
        uint256 lit;
        Packet[] memory packets;
        if (t == 4) {
            (lit, nexti) = literal(bits, i);
        } else {
            (packets, nexti) = operator(bits, i, end);
        }
        p = Packet({version: v, ptype: t, literal: lit, packets: packets});
    }

    function literal(bytes memory bits, uint256 i)
        private
        pure
        returns (uint256 lit, uint256 nexti)
    {
        uint256 more = 1;
        while (more > 0) {
            lit = (lit << 4) + decimal(bits, i + 1, i + 1 + 4);
            more = bit(bits, i);
            i += 5;
        }
        nexti = i;
    }

    function operator(
        bytes memory bits,
        uint256 i,
        uint256 end
    ) private pure returns (Packet[] memory packets, uint256 nexti) {
        uint8 id = bit(bits, i++);
        if (id == 0) {
            uint256 len = decimal(bits, i, i += 15);
            nexti = i + len;
            while (i < nexti) {
                (Packet memory p, uint256 ni) = packet(bits, i, end);
                packets = append(packets, p);
                i = ni;
            }
        } else {
            uint256 n = decimal(bits, i, i += 11);
            while (n > 0) {
                (Packet memory p, uint256 ni) = packet(bits, i, end);
                packets = append(packets, p);
                nexti = i = ni;
                n--;
            }
        }
    }

    function append(Packet[] memory packets, Packet memory p)
        private
        pure
        returns (Packet[] memory copy)
    {
        uint256 n = packets.length;
        copy = new Packet[](n + 1);
        copy[n] = p;
        for (uint256 i = 0; i < n; i++) copy[i] = packets[i];
    }
}

contract _16 is _16Parser {
    function main(string calldata input) external returns (uint256, uint256) {
        Packet memory packet = parse(input);
        return (p1(packet), p2(packet));
    }

    function p1(Packet memory packet) private returns (uint256) {
        return versionSum(packet);
    }

    function p2(Packet memory packet) private returns (uint256) {
        return eval(packet);
    }

    function versionSum(Packet memory packet) private returns (uint256 r) {
        r = packet.version;
        for (uint256 i = 0; i < packet.packets.length; i++) {
            r += versionSum(packet.packets[i]);
        }
    }

    function eval(Packet memory packet) private returns (uint256) {
        uint256 t = packet.ptype;
        Packet[] memory packets = packet.packets;
        if (t == 0) return sum(packets);
        if (t == 1) return product(packets);
        if (t == 2) return min(packets);
        if (t == 3) return max(packets);
        if (t == 4) return packet.literal;
        if (t == 5) return eval(packets[0]) < eval(packets[1]) ? 1 : 0;
        if (t == 6) return eval(packets[0]) > eval(packets[1]) ? 1 : 0;
        if (t == 7) return eval(packets[0]) == eval(packets[1]) ? 1 : 0;
        revert();
    }

    function sum(Packet[] memory packets) private returns (uint256 r) {
        for (uint256 i = 0; i < packets.length; i++) {
            r += eval(packets[i]);
        }
    }

    function product(Packet[] memory packets) private returns (uint256 r) {
        r = 1;
        for (uint256 i = 0; i < packets.length; i++) {
            r *= eval(packets[i]);
        }
    }

    function min(Packet[] memory packets) private returns (uint256 r) {
        r = eval(packets[0]);
        for (uint256 i = 1; i < packets.length; i++) {
            uint256 e = eval(packets[i]);
            if (e < r) r = e;
        }
    }

    function max(Packet[] memory packets) private returns (uint256 r) {
        r = eval(packets[0]);
        for (uint256 i = 1; i < packets.length; i++) {
            uint256 e = eval(packets[i]);
            if (e > r) r = e;
        }
    }
}

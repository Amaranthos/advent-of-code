module day16;

import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;
import std.typecons;

void main()
{
	File("day16.in", "r")
		.readln
		.decode
		.parseTransmission
		.writeln;
}

ubyte[] decode(in string transmission)
{
	ubyte[] packets;

	enum ubyte[][char] encoding = [
			'0': [0, 0, 0, 0],
			'1': [0, 0, 0, 1],
			'2': [0, 0, 1, 0],
			'3': [0, 0, 1, 1],
			'4': [0, 1, 0, 0],
			'5': [0, 1, 0, 1],
			'6': [0, 1, 1, 0],
			'7': [0, 1, 1, 1],
			'8': [1, 0, 0, 0],
			'9': [1, 0, 0, 1],
			'A': [1, 0, 1, 0],
			'B': [1, 0, 1, 1],
			'C': [1, 1, 0, 0],
			'D': [1, 1, 0, 1],
			'E': [1, 1, 1, 0],
			'F': [1, 1, 1, 1],
		];

	foreach (digit; transmission)
	{
		if (digit in encoding)
		{
			packets ~= encoding[digit];
		}
		else
		{
			assert(false, "missing: " ~ digit);
		}
	}

	return packets;
}

unittest
{
	const packets = "D2FE28".decode;

	assert(packets == [
			1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0
		], format!"Expected %s, received: %s"([
			1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0
		], packets));
}

int parseTransmission(in ubyte[] packets)
{
	int sum;
	auto read = packets[0 .. $];
	while (read.length)
	{
		if (read.sum == 0)
		{
			break;
		}

		sum += read[0] << 2 | read[1] << 1 | read[2];
		read = read[3 .. $];
		const type = read[0] << 2 | read[1] << 1 | read[2];
		read = read[3 .. $];

		switch (type)
		{
		case 4:
			const literal = parseLiteral(read);
			read = read[literal.length .. $];
			break;

		default:
			const lengthType = read[0];
			read = read[1 .. $];

			if (lengthType)
			{
				const count = read[0 .. 11].intFromBits;
				read = read[11 .. $];
			}
			else
			{
				const length = read[0 .. 15].intFromBits;
				read = read[15 .. $];
			}

			break;
		}
	}

	return sum;
}

unittest
{
	const packets = "8A004A801A8002F478".decode;
	const sum = parseTransmission(packets);
	assert(sum == 16, format!"Expected %s, received: %s"(16, sum));
}

unittest
{
	const packets = "620080001611562C8802118E34".decode;
	const sum = parseTransmission(packets);
	assert(sum == 12, format!"Expected %s, received: %s"(12, sum));
}

unittest
{
	const packets = "C0015000016115A2E0802F182340".decode;
	const sum = parseTransmission(packets);
	assert(sum == 23, format!"Expected %s, received: %s"(23, sum));
}

unittest
{
	const packets = "A0016C880162017C3686B18A3D4780".decode;
	const sum = parseTransmission(packets);
	assert(sum == 31, format!"Expected %s, received: %s"(31, sum));
}

uint intFromBits(in ubyte[] bits)
{
	uint value;
	foreach (count, bit; bits)
	{
		value |= bit << (bits.length - 1 - count);
	}
	return value;
}

alias Literal = Tuple!(int, "value", int, "length");
Literal parseLiteral(in ubyte[] packets)
{
	ubyte[] bits;
	int idx;
	while (packets[idx] == 1)
	{
		bits ~= packets[idx + 1 .. idx + 5];
		idx += 5;
	}
	bits ~= packets[idx + 1 .. idx + 5];

	return Literal(bits.intFromBits, idx + 5);
}

unittest
{
	const ubyte[] packets = [
		1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0
	];
	const literal = packets.parseLiteral;
	assert(literal.value == 2021, format!"Expected %s, received: %s"(2021, literal.value));
}

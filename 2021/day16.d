module day16;

import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;
import std.range;
import std.typecons;

void main()
{
	auto packets = File("day16.in", "r")
		.readln
		.decode;

	packets
		.parsePacket
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

alias Result = Tuple!(ulong, "val", ulong, "ver");
Result parsePacket(ref ubyte[] packets, uint depth = 0)
{
	ulong ver = packets[0] << 2 | packets[1] << 1 | packets[2];
	packets = packets[3 .. $];

	const type = packets[0] << 2 | packets[1] << 1 | packets[2];
	packets = packets[3 .. $];

	ulong result;
	if (type == 4)
	{
		const literal = parseLiteral(packets);
		packets = packets[literal.length .. $];
		result = literal.value;

	}
	else
	{
		const lengthType = packets[0];
		packets = packets[1 .. $];

		Result[] subResults;
		if (lengthType)
		{
			const count = packets[0 .. 11].intFromBits;
			packets = packets[11 .. $];

			foreach (i; 0 .. count)
			{
				subResults ~= parsePacket(packets, depth + 1);
			}
		}
		else
		{
			const length = packets[0 .. 15].intFromBits;
			packets = packets[15 .. $];

			auto temp = packets[0 .. length];
			while (temp.length)
			{
				subResults ~= parsePacket(temp, depth + 1);
			}

			packets = packets[length .. $];
		}

		final switch (type)
		{
		case 0:
			result = 0;
			foreach (r; subResults)
			{
				result += r.val;
				ver += r.ver;
			}
			break;

		case 1:
			result = 1;
			foreach (r; subResults)
			{
				result *= r.val;
				ver += r.ver;
			}
			break;
		case 2:
			result = ulong.max;
			foreach (r; subResults)
			{
				result = min(result, r.val);
				ver += r.ver;
			}
			break;
		case 3:
			result = ulong.min;
			foreach (r; subResults)
			{
				result = max(result, r.val);
				ver += r.ver;
			}
			break;
		case 5:
			assert(subResults.length == 2);
			const p1 = subResults[0];
			const p2 = subResults[1];
			result = (p1.val > p2.val) ? 1 : 0;

			ver += p1.ver + p2.ver;
			break;
		case 6:
			assert(subResults.length == 2);
			const p1 = subResults[0];
			const p2 = subResults[1];
			result = (p1.val < p2.val) ? 1 : 0;
			ver += p1.ver + p2.ver;
			break;
		case 7:
			assert(subResults.length == 2);
			const p1 = subResults[0];
			const p2 = subResults[1];
			result = (p1.val == p2.val) ? 1 : 0;
			ver += p1.ver + p2.ver;
			break;
		}
	}

	if (depth == 0)
	{
		writeln;
		assert(packets.count!"a > 0" == 0);
	}

	return Result(result, ver);
}

unittest
{
	auto packets = "8A004A801A8002F478".decode;
	const sum = parsePacket(packets)[1];
	assert(sum == 16, format!"Expected %s, received: %s"(16, sum));
}

unittest
{
	auto packets = "620080001611562C8802118E34".decode;
	const sum = parsePacket(packets)[1];
	assert(sum == 12, format!"Expected %s, received: %s"(12, sum));
}

unittest
{
	auto packets = "C0015000016115A2E0802F182340".decode;
	const sum = parsePacket(packets)[1];
	assert(sum == 23, format!"Expected %s, received: %s"(23, sum));
}

unittest
{
	auto packets = "A0016C880162017C3686B18A3D4780".decode;
	const sum = parsePacket(packets)[1];
	assert(sum == 31, format!"Expected %s, received: %s"(31, sum));
}

unittest
{
	auto packets = "C200B40A82".decode;
	const val = parsePacket(packets).val;
	assert(val == 3, format!"Expected %s, received: %s"(3, val));
}

unittest
{
	auto packets = "04005AC33890".decode;
	const val = parsePacket(packets).val;
	assert(val == 54, format!"Expected %s, received: %s"(54, val));
}

unittest
{
	auto packets = "880086C3E88112".decode;
	const val = parsePacket(packets).val;
	assert(val == 7, format!"Expected %s, received: %s"(7, val));
}

unittest
{
	auto packets = "CE00C43D881120".decode;
	const val = parsePacket(packets).val;
	assert(val == 9, format!"Expected %s, received: %s"(9, val));
}

unittest
{
	auto packets = "D8005AC2A8F0".decode;
	const val = parsePacket(packets).val;
	assert(val == 1, format!"Expected %s, received: %s"(1, val));
}

unittest
{
	auto packets = "F600BC2D8F".decode;
	const val = parsePacket(packets).val;
	assert(val == 0, format!"Expected %s, received: %s"(0, val));
}

unittest
{
	auto packets = "9C005AC2F8F0".decode;
	const val = parsePacket(packets).val;
	assert(val == 0, format!"Expected %s, received: %s"(0, val));
}

unittest
{
	auto packets = "9C0141080250320F1802104A08".decode;
	const val = parsePacket(packets).val;
	assert(val == 1, format!"Expected %s, received: %s"(1, val));
}

ulong intFromBits(in ubyte[] bits)
{
	ulong value;
	foreach (count, bit; bits)
	{
		value = (value << 1) + bit;
	}
	return value;
}

alias Literal = Tuple!(ulong, "value", int, "length");
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

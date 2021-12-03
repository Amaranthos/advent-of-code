module day03;

import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.typecons;

void main()
{
	const rates = File("day03.in", "r").byLine.map!(to!string)
		.array.countBits;
	(rates.gamma * rates.epsilon).writeln;
}

const ANSI_OFFSET = 48;
alias Rates = Tuple!(int, "gamma", int, "epsilon");

Rates countBits(in string[] values)
{
	int[] counts = new int[values[0].length];

	foreach (value; values)
	{
		foreach (idx, pos; value)
		{
			counts[idx] += pos.to!int - ANSI_OFFSET;
		}
	}

	const l = cast(int)(values.length * 0.5);

	uint gamma = 0;
	uint epsilon = 0;
	foreach (idx, count; counts)
	{
		const offset = (
			counts.length - 1 - idx);

		gamma |= (count > l ? 1 : 0) << offset;
		epsilon |= 1 << offset;
	}

	return Rates(gamma, epsilon - gamma
	);
}

unittest
{
	const report = [
		"00100",
		"11110",
		"10110",
		"10111",
		"10101",
		"01111",
		"00111",
		"11100",
		"10000",
		"11001",
		"00010",
		"01010",
	];

	const counts = report.countBits;

	assert(counts.gamma == 0b10110);
	assert(counts.epsilon == 0b01001);
}

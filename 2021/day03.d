module day03;

import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.typecons;

void main()
{
	const values = File("day03.in", "r").byLine.map!(to!string)
		.array;
	const rates = values.readRates;
	(rates.gamma * rates.epsilon).writeln;

	(values
			.readOxy * values.readC02).writeln;
}

const ANSI_OFFSET = 48;
alias Rates = Tuple!(int, "gamma", int, "epsilon");

Rates readRates(in string[] values)
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

	const counts = report.readRates;

	assert(counts.gamma == 0b10110);
	assert(counts.epsilon == 0b01001);
}

int readOxy(in string[] values)
{
	string[] copy = values.dup;
	foreach (pos; 0 .. copy[0].length)
	{
		copy = filterValues!(">=")(copy, pos);
	}

	int reading = 0;
	const ints = copy[0].map!(a => a.to!int - ANSI_OFFSET).array;
	foreach (idx, i; ints)
	{
		reading |= i << (values[0].length - 1 - idx);
	}
	return reading;
}

string[] filterValues(string predicate)(in string[] values, ulong pos)
{
	int c0 = 0;
	int c1 = 0;
	foreach (value; values)
	{
		switch (value[pos])
		{
		case '0':
			++c0;
			continue;
		case '1':
			++c1;
			continue;
		default:
			assert(false);
		}
	}

	const char filter = mixin("c1 " ~ predicate ~ "c0 ? '1' : '0'");

	return values.dup.filter!(a => a[pos] == filter).array;
}

unittest
{
	const values = [
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

	const pass1 = filterValues!(">=")(values, 0);

	assert(pass1.equal([
			"11110",
			"10110",
			"10111",
			"10101",
			"11100",
			"10000",
			"11001",
		]));

	const pass2 = filterValues!(">=")(pass1, 1);

	assert(pass2.equal([
				"10110",
				"10111",
				"10101",
				"10000",
			]));

	const pass3 = filterValues!(">=")(pass2, 2);

	assert(pass3.equal([
				"10110",
				"10111",
				"10101",
			]));

	const pass4 = filterValues!(">=")(pass3, 3);

	assert(pass4.equal([
				"10110",
				"10111",
			]));

	const pass5 = filterValues!(">=")(pass4, 4);

	assert(pass5.equal([
				"10111",
			]));
}

int readC02(in string[] values)
{
	string[] copy = values.dup;
	int pos = 0;
	while (copy.length > 1)
	{
		int c0 = 0;
		int c1 = 0;
		foreach (value; copy)
		{
			switch (value[pos])
			{
			case '0':
				++c0;
				continue;
			case '1':
				++c1;
				continue;
			default:
				assert(false);
			}
		}
		const char filter = c0 <= c1 ? '0' : '1';

		copy = copy.filter!(
			a => a[pos] == filter).array;

		++pos;
	}

	int reading = 0;
	const ints = copy[0].map!(a => a.to!int - ANSI_OFFSET).array;
	foreach (idx, i; ints)
	{
		reading |= i << (values[0].length - 1 - idx);
	}
	return reading;
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

	assert(report.readOxy == 23);
	assert(report.readC02 == 10);
}

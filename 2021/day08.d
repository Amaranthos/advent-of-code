import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;
import std.typecons;

void main()
{
	File("day08.in", "r")
		.byLine
		.map!(to!string)
		.map!(parseLine)
		.map!(solveMapping)
		.sum
		.writeln;
}

alias Signal = string[10];
alias Output = string[4];

Tuple!(Signal, Output) parseLine(string line)
{
	auto parts = line.split(" | ").map!(split);
	return tuple(parts[0].staticArray!10, parts[1].staticArray!4);
}

unittest
{
	const line = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf";

	const Signal expectedSignal = [
		"acedgfb", "cdfbe",
		"gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"
	];
	const Output expectedOutput = [
		"cdfeb", "fcadb", "cdfeb", "cdbaf"
	];

	const parsed = parseLine(line);

	assert(parsed[0] == expectedSignal, format!"Expected %s, received: %s"(expectedSignal, parsed[0]));
	assert(parsed[1] == expectedOutput, format!"Expected %s, received: %s"(expectedOutput, parsed[1]));
}

int solveMapping(Tuple!(Signal, Output) pair)
{
	const signal = pair[0].array;
	const output = pair[1].array;

	const one = signal.filter!(s => s.length == 2).array[0];
	const four = signal.filter!(s => s.length == 4).array[0];

	int[] digits;
	foreach (digit; output)
	{
		switch (digit.length)
		{
		case 2:
			digits ~= 1;
			break;
		case 4:
			digits ~= 4;
			break;
		case 3:
			digits ~= 7;
			break;
		case 7:
			digits ~= 8;
			break;

		case 5:
			digits ~= count!(a => four.canFind(a.to!string))(digit) == 2 ? 2 : count!(
				a => one.canFind(a.to!string))(digit) == 2 ? 3 : 5;
			break;

		case 6:
			digits ~= count!(a => four.canFind(a.to!string))(digit) == 4 ? 9 : count!(
				a => one.canFind(a.to!string))(digit) == 2 ? 0 : 6;
			break;

		default:
			assert(false, digit);
		}
	}

	return 1000 * digits[0] + 100 * digits[1] + 10 * digits[2] + digits[3];
}

unittest
{
	const line = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf";
	const parsed = parseLine(line);
	const value = parsed.solveMapping;

	assert(value == 5353, format!"Expected %s, received: %s"(5353, value));

}

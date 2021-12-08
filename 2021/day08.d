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
		.array
		.countDigits
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

int[] findDigits(in string[] value)
{
	int[] digits;
	foreach (digit; value)
	{
		switch (digit.length)
		{
		case 2:
			digits ~= 1;
			continue;
		case 3:
			digits ~= 7;
			continue;
		case 4:
			digits ~= 4;
			continue;
		case 7:
			digits ~= 8;
			continue;

		default:
			continue;
		}
	}

	return digits;
}

unittest
{
	const Signal signal = [
		"acedgfb", "cdfbe",
		"gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"
	];

	int[] digits = signal.findDigits;
	int[] expectedDigits = [8, 7, 4, 1];

	assert(digits == expectedDigits, format!"Expected %s, received: %s"(expectedDigits, digits));

	const Output output = [
		"ab", "fcadb", "cdfeb", "cdbaf"
	];

	digits = output.findDigits;
	expectedDigits = [1];

	assert(digits == expectedDigits, format!"Expected %s, received: %s"(expectedDigits, digits));
}

int countDigits(in string[] lines)
{
	return reduce!((count, digits) => count += digits.length)(0, lines.map!(parseLine)
			.map!(line => line[1].findDigits));
}

unittest
{
	const input = [
		"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
		"edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
		"fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
		"fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
		"aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
		"fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
		"dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
		"bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
		"egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
		"gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce",
	];

	const count = input.countDigits;

	assert(count == 26, format!"Expected %s, received: %s"(26, count));
}

import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.range;
import std.string;
import std.typecons;

const polymerTemplate = "CHBBKPHCPHPOKNSNCOVB";

void main()
{
	const rules = File("day14.in", "r")
		.byLine
		.map!(line => line.split(" -> ").map!(to!string))
		.map!(a => Rule(a[0], a[1]))
		.array;

	sim(polymerTemplate, rules, 40).writeln;
}

alias Rule = Tuple!(string, string);

long sim(in string polymerTemplate, in Rule[] rules, in ulong numSteps)
{
	long[string] freq;
	foreach (window; polymerTemplate.slide(2))
	{
		++freq[window.to!string];
	}

	string[][string] patterns;
	foreach (rule; rules)
	{
		patterns[rule[0]] = [
			format!"%s%s"(rule[0][0], rule[1]),
			format!"%s%s"(rule[1], rule[0][1])
		];
	}

	foreach (step; 0 .. numSteps)
	{
		long[string] nextFreq;
		foreach (key, value; freq.dup)
		{
			foreach (nextPair; patterns[key])
			{
				nextFreq[nextPair] += value;
			}
		}
		freq = nextFreq;
	}

	long[char] counts;
	++counts[polymerTemplate[0]];
	foreach (key, value; freq)
	{
		if (key[1] in counts)
		{
			counts[key[1]] += value;
		}
		else
		{
			counts[key[1]] = value;
		}
	}

	const max = counts.byKeyValue.maxElement!(
		v => v.value);
	const min = counts.byKeyValue.minElement!(
		v => v.value);

	return max.value - min.value;
}

unittest
{
	assert(
		sim("NNCB", [
				Rule("CH", "B",),
				Rule("HH", "N",),
				Rule("CB", "H",),
				Rule("NH", "C",),
				Rule("HB", "C",),
				Rule("HC", "B",),
				Rule("HN", "C",),
				Rule("NN", "C",),
				Rule("BH", "H",),
				Rule("NC", "B",),
				Rule("NB", "B",),
				Rule("BN", "B",),
				Rule("BB", "N",),
				Rule("BC", "B",),
				Rule("CC", "N",),
				Rule("CN", "C",)
			], 10) == 1588);
}

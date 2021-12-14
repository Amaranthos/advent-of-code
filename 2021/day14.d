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

	const polymer = polymerTemplate.applyRules(rules, 10);
	const occurances = polymer.countOccurances;

	(occurances[0][1] - occurances[1][1]).writeln;
}

alias Rule = Tuple!(string, string);

string applyRules(in string polymerTemplate, in Rule[] rules, in ulong numSteps)
in (numSteps <= rules.length)
{
	string polymer = polymerTemplate.dup;

	foreach (step; 0 .. numSteps)
	{
		string edit = "" ~ polymer[0];
		foreach (idx; 1 .. polymer.length)
		{
			const a = polymer[idx - 1];
			const b = polymer[idx];

			foreach (rule; rules)
			{
				if (rule[0] == [a, b])
				{
					edit ~= rule[1];
				}
			}

			edit ~= b;
		}
		polymer = edit;
	}

	return polymer;
}

alias Occurances = Tuple!(Tuple!(char, ulong), "max", Tuple!(char, ulong), "min");
Occurances countOccurances(in string polymer)
{
	ulong[char] counts;
	foreach (element; polymer)
	{
		counts[element] = polymer.count(element);
	}

	const max = counts.byKeyValue.maxElement!(
		v => v.value);
	const min = counts.byKeyValue.minElement!(
		v => v.value);
	return Occurances(
		tuple(max.key, max.value),
		tuple(min.key, min.value)
	);
}

unittest
{
	const polymerTemplate = "NNCB";
	const rules = [
		Rule("CH", "B"),
		Rule("HH", "N"),
		Rule("CB", "H"),
		Rule("NH", "C"),
		Rule("HB", "C"),
		Rule("HC", "B"),
		Rule("HN", "C"),
		Rule("NN", "C"),
		Rule("BH", "H"),
		Rule("NC", "B"),
		Rule("NB", "B"),
		Rule("BN", "B"),
		Rule("BB", "N"),
		Rule("BC", "B"),
		Rule("CC", "N"),
		Rule("CN", "C"),
	];
	assert(applyRules(polymerTemplate, rules, 1) == "NCNBCHB");
	assert(applyRules(polymerTemplate, rules, 2) == "NBCCNBBBCBHCB");
	assert(applyRules(polymerTemplate, rules, 3) == "NBBBCNCCNBBNBNBBCHBHHBCHB");
	assert(applyRules(polymerTemplate, rules, 4) == "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB");

	const polymer = applyRules(polymerTemplate, rules, 10);
	const occurances = countOccurances(
		polymer);
	assert(occurances == Occurances(tuple('B', 1749.to!ulong), tuple('H', 161.to!ulong)), format!"Expected %-(%s,%s%), received: %-(%s,%s%)"(
			Occurances(tuple('B', 1749
			.to!ulong), tuple('H', 161.to!ulong)), occurances));
}

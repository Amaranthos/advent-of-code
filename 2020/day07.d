import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.range;
import std.regex;
import std.stdio;
import std.string;
import std.typecons;

void main()
{
	auto bags = readText("day07.input").parseRules;
	bags.count("shiny gold").writeln;
	bags.countContains("shiny gold").writeln;
}

struct Bag
{
	int[string] contains;
}

Bag[string] parseRules(in string data)
{
	// dfmt off
	auto bags = data
	.splitter('\n')
	.map!(a => a
		.dropBack(1)
		.splitter("contain")
		.map!(a => a
			.replaceAll(regex(" ?bags?"), "")
			.strip
		)
	)
	.map!((a) {
		auto contains = a.array[1]
			.splitter(", ")
			.map!((a) {
				auto match = a.matchFirst(regex(`^(\d+)? ?(.*)$`));
				if (!match.empty)
				{
					auto count = match[1];
					auto desc = match[2];
					return tuple(desc, (!count.empty) ? count.to!int : 0);
				}
				assert(false, format("%s", a));
			});
		Bag bag;
		foreach (c; contains)
		{
			bag.contains[c[0]] = c[1];
		}
		return tuple(bag, a.array[0]);
	})
	.array;

	Bag[string] map;
	foreach (bag; bags)
	{
		map[bag[1]] = bag[0];
	}

	return map;
}

auto count(in Bag[string] bags, in string name)
{
	return bags.keys.filter!((bag) => bags.contains(bags[bag], name)).array.length;
}

bool contains(in Bag[string] bags, in Bag bag, in string name)
{
	if (name in bag.contains) return true;
	bool does = false;
	foreach (key; bag.contains.keys.filter!(k => k != "no other"))
	{
		does = does || bags.contains(bags[key], name);
	}
	return does;
}

unittest
{
	const rules = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.";
	const bags = rules.parseRules;
	assert(bags.length == 9);
	assert(bags.count("shiny gold") == 4);
}

uint countContains(in Bag[string] bags, in string name)
{
	uint total;
	foreach (bag, count; bags[name].contains)
	{
		total += count;
		if (bag == "no other") continue;
		total += countContains(bags, bag) * count;
	}
	return total;
}

unittest
{
	const rules = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.";
	const bags = rules.parseRules;
	bags.countContains("shiny gold").writeln;
	assert(bags.countContains("shiny gold") == 32);
}

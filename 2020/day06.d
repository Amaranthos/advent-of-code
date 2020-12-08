import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.regex;
import std.stdio;

void main()
{
	auto data = "day06.input".readText;
	data.anyone.writeln;
	data.everyone.writeln;
}

auto anyone(string data)
{
	// dfmt off
	return data
		.split("\n\n")
		.map!(a => a
			.split("\n")
			.join("")
			.split("")
			.sort
			.uniq)
		.map!(a => a
			.array
			.length)
		.sum;
	// dfmt on
}

unittest
{
	assert("abc

a
b
c

ab
ac

a
a
a
a

b".anyone == 11);
}

auto everyone(string data)
{
	// dfmt off
	const groups =
	 data
		.split("\n\n")
		.map!(a => a
			.split("\n")
			.map!(a => a.split("")).array
		).array;
	// dfmt on

	uint everyoneCount;
	foreach (group; groups)
	{
		uint[string] counts;
		foreach (person; group)
		{
			foreach (question; person)
			{
				++counts[question];
			}
		}
		foreach (count; counts)
		{
			if (count == group.length)
			{
				++everyoneCount;
			}
		}
	}
	return everyoneCount;
}

auto counts(string people)
{
	// int[string] questions;
	// const q = people.split("").each!((q) { questions[q]++; });
	// writeln(questions);
	// return questions;
}

unittest
{
	assert("abc

a
b
c

ab
ac

a
a
a
a

b".everyone == 6);
}

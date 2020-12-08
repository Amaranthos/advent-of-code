import std.algorithm;
import std.array;
import std.file;
import std.regex;
import std.stdio;

void main()
{
	"day06.input".readText.count.writeln;
}

auto count(string data)
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

b".count == 11);
}

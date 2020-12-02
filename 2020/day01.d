import std.stdio;
import std.conv : to;
import std.algorithm : reduce, cartesianProduct, sum;
import std.range : only;
import std.typecons : Tuple, tuple;

void main()
{
	const entries = readInput();

	writeln(entries.sumTo2020().reduce!((a, b) => a * b));
	writeln(entries.sum3To2020().reduce!((a, b) => a * b));
}

auto sumTo2020(const uint[] entries) pure nothrow @safe
{
	foreach (pair; cartesianProduct(entries, entries))
	{
		if (pair.expand.only.sum == 2020)
		{
			return pair;
		}
	}
	assert(false);
}

unittest
{
	const entries = sumTo2020([1721, 979, 366, 299, 675, 1456]);
	assert(entries == tuple(1721, 299));
}

auto sum3To2020(const uint[] entries) pure nothrow @safe
{
	foreach (pair; cartesianProduct(entries, entries, entries))
	{
		if (pair.expand.only.sum == 2020)
		{
			return pair;
		}
	}
	assert(false);
}

unittest
{
	const entries = sum3To2020([1721, 979, 366, 299, 675, 1456]);
	assert(entries == tuple(979, 366, 675));
}

uint[] readInput()
{
	uint[] result;
	File file = File("day01.input", "r");

	foreach (line; file.byLine())
	{
		result ~= to!int(line);
	}

	return result;
}

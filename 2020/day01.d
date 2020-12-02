import std.stdio;
import std.conv : to;
import std.algorithm : reduce, cartesianProduct, sum, map;
import std.range : only, iota;
import std.typecons : Tuple, tuple;
import std.array : array;
import std.typetuple : TypeTuple;

void main()
{
	const entries = readInput();

	writeln(entries.findSumsTo2020!2().reduce!((a, b) => a * b));
	writeln(entries.findSumsTo2020!3().reduce!((a, b) => a * b));
}

auto findSumsTo2020(uint count)(const uint[] entries) pure @safe
{
	auto array = to!(uint[][count])(iota(count).map!((a) => entries).array);
	foreach (pair; asTuple!(uint[], count)(array).expand.cartesianProduct)
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
	assert(findSumsTo2020!2([1721, 979, 366, 299, 675, 1456]) == tuple(1721, 299));
	assert(findSumsTo2020!3([1721, 979, 366, 299, 675, 1456]) == tuple(979, 366, 675));
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

template list(T, size_t n)
{
	static if (n <= 1)
	{
		alias list = T;
	}
	else
	{
		alias list = TypeTuple!(T, list!(T, n - 1));
	}
}

auto asTuple(T, size_t n)(ref T[n] arr)
{
	return Tuple!(list!(T, n))(arr);
}

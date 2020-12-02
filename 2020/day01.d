import std.stdio;
import std.conv : to;
import std.algorithm : reduce;

void main()
{
	const entries = readInput();
	writeln(entries.sum3To2020().reduce!((a, b) => a * b));
}

uint[2] sumTo2020(const uint[] entries)
{
	foreach (entry1; entries)
	{
		foreach (entry2; entries)
		{
			if (entry1 + entry2 == 2020)
			{
				return [entry1, entry2];
			}
		}
	}
	assert(false);
}

unittest
{
	const entries = sumTo2020([1721, 979, 366, 299, 675, 1456]);
	assert(entries == [1721, 299]);
}

uint[3] sum3To2020(const uint[] entries)
{
	foreach (entry1; entries)
	{
		foreach (entry2; entries)
		{
			foreach (entry3; entries)
			{
				if (entry1 + entry2 + entry3 == 2020)
				{
					return [entry1, entry2, entry3];
				}
			}
		}
	}
	assert(false);
}

unittest
{
	const entries = sum3To2020([1721, 979, 366, 299, 675, 1456]);
	assert(entries == [979, 366, 675]);
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

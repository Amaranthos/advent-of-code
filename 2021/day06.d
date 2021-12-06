import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;

void main()
{
	File("day06.in", "r")
		.readln
		.split(',')
		.map!(to!int)
		.array
		.sim(80)
		.length
		.writeln;
}

int[] sim(in int[] seed, int days)
{
	int[] result = seed.dup;

	if (days == 0)
	{
		return result;
	}

	foreach (idx, fish; seed)
	{
		if (fish == 0)
		{
			result ~= 8;
			result[idx] = 6;
		}
		else
		{
			--result[idx];
		}
	}

	return result.sim(days - 1);
}

unittest
{
	int[] seed = [3, 4, 3, 1, 2];

	assert(sim(seed, 1).equal([2, 3, 2, 0, 1]));
	assert(sim(seed, 2).equal([1, 2, 1, 6, 0, 8]));
	assert(sim(seed, 3).equal([0, 1, 0, 5, 6, 7, 8]));
	assert(sim(seed, 4).equal([6, 0, 6, 4, 5, 6, 7, 8, 8]));
	assert(sim(seed, 5).equal([5, 6, 5, 3, 4, 5, 6, 7, 7, 8]));
	assert(sim(seed, 6).equal([4, 5, 4, 2, 3, 4, 5, 6, 6, 7]));
	assert(sim(seed, 7).equal([3, 4, 3, 1, 2, 3, 4, 5, 5, 6]));
	assert(sim(seed, 8).equal([2, 3, 2, 0, 1, 2, 3, 4, 4, 5]));
	assert(sim(seed, 9).equal([1, 2, 1, 6, 0, 1, 2, 3, 3, 4, 8]));
	assert(sim(seed, 10).equal([0, 1, 0, 5, 6, 0, 1, 2, 2, 3, 7, 8]));
	assert(sim(seed, 11).equal([6, 0, 6, 4, 5, 6, 0, 1, 1, 2, 6, 7, 8, 8, 8]));
	assert(sim(seed, 12).equal([
			5, 6, 5, 3, 4, 5, 6, 0, 0, 1, 5, 6, 7, 7, 7, 8, 8
		]));
	assert(sim(seed, 13).equal([
			4, 5, 4, 2, 3, 4, 5, 6, 6, 0, 4, 5, 6, 6, 6, 7, 7, 8, 8
		]));
	assert(sim(seed, 14).equal([
			3, 4, 3, 1, 2, 3, 4, 5, 5, 6, 3, 4, 5, 5, 5, 6, 6, 7, 7, 8
		]));
	assert(sim(seed, 15).equal([
			2, 3, 2, 0, 1, 2, 3, 4, 4, 5, 2, 3, 4, 4, 4, 5, 5, 6, 6, 7
		]));
	assert(sim(seed, 16).equal([
			1, 2, 1, 6, 0, 1, 2, 3, 3, 4, 1, 2, 3, 3, 3, 4, 4, 5, 5, 6, 8
		]));
	assert(sim(seed, 17).equal([
			0, 1, 0, 5, 6, 0, 1, 2, 2, 3, 0, 1, 2, 2, 2, 3, 3, 4, 4, 5, 7, 8
		]));
	assert(sim(seed, 18).equal([
			6, 0, 6, 4, 5, 6, 0, 1, 1, 2, 6, 0, 1, 1, 1, 2, 2, 3, 3, 4, 6, 7, 8, 8,
			8, 8
		]));
	assert(sim(seed, 18).length == 26);
}

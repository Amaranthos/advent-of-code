import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.stdio;

void main()
{
	const seed = File("day06.in", "r")
		.readln
		.split(',')
		.map!(to!int)
		.array;

	seed.sim(80)
		.writeln;
	seed.sim(256)
		.writeln;
}

long sim(in int[] seed, int days)
{
	long[] result = new long[](9);

	foreach (s; seed)
	{
		++result[s];
	}

	foreach (day; 0 .. days)
	{
		foreach (idx, value; result.dup)
		{
			if (value > 0)
			{
				result[idx] -= value;

				if (idx == 0)
				{
					result[8] += value;
					result[6] += value;
				}
				else
				{
					result[idx - 1] += value;
				}
			}
		}
	}

	long sum = 0;
	foreach (value; result)
	{
		sum += value;
	}

	return sum;
}

unittest
{
	int[] seed = [3, 4, 3, 1, 2];

	assert(sim(seed, 1) == 5);
	assert(sim(seed, 2) == 6);
	assert(sim(seed, 3) == 7);
	assert(sim(seed, 4) == 9);
	assert(sim(seed, 5) == 10);
	assert(sim(seed, 6) == 10);
	assert(sim(seed, 7) == 10);
	assert(sim(seed, 8) == 10);
	assert(sim(seed, 9) == 11);
	assert(sim(seed, 10) == 12);
	assert(sim(seed, 11) == 15);
	assert(sim(seed, 12) == 17);
	assert(sim(seed, 13) == 19);
	assert(sim(seed, 14) == 20);
	assert(sim(seed, 15) == 20);
	assert(sim(seed, 16) == 21);
	assert(sim(seed, 17) == 22);
	assert(sim(seed, 18) == 26);
	assert(sim(seed, 80) == 5934);
	assert(sim(seed, 256) == 26_984_457_539);
}

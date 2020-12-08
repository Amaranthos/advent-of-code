import std.algorithm;
import std.conv;
import std.range;
import std.stdio;

void main()
{
	const seats = File("day05.input").byLineCopy.map!(a => a.findSeat).array;
	uint[] notFound = [];
	foreach (elem; iota(128 * 8))
	{
		if (!seats.canFind(elem))
		{
			notFound ~= elem;
		}
	}
	notFound.filter!(a => seats.canFind(a - 1) && seats.canFind(a + 1)).writeln;
}

uint findRow(in string input)
{
	uint guess;
	uint min = 0, max = 127;
	for (uint count = 0; count < input.length; ++count)
	{
		guess = ((min + max) / 2);

		const code = input[count];
		final switch (code)
		{
		case 'F':
			max = guess;
			break;
		case 'B':
			min = ++guess;
			break;
		}
	}
	return guess;
}

unittest
{
	assert("FBFBBFF".findRow == 44);
	assert("BFFFBBF".findRow == 70);
	assert("FFFBBBF".findRow == 14);
	assert("BBFFBBF".findRow == 102);
}

uint findColumn(in string input)
{
	uint guess;
	uint min = 0, max = 7;
	for (uint count = 0; count < input.length; ++count)
	{
		guess = ((min + max) / 2);

		const code = input[count];
		final switch (code)
		{
		case 'L':
			max = guess;
			break;
		case 'R':
			min = ++guess;
			break;
		}
	}
	return guess;
}

unittest
{
	assert("RLR".findColumn == 5);
	assert("RRR".findColumn == 7);
	assert("RRR".findColumn == 7);
	assert("RLL".findColumn == 4);
}

uint findSeat(string input)
{
	const row = input.take(7).to!string.findRow;
	const column = input.tail(3).to!string.findColumn;
	return row * 8 + column;
}

unittest
{
	assert("FBFBBFFRLR".findSeat == 357);
	assert("BFFFBBFRRR".findSeat == 567);
	assert("FFFBBBFRRR".findSeat == 119);
	assert("BBFFBBFRLL".findSeat == 820);
}

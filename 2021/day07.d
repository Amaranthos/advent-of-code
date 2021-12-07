import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.stdio;
import std.string;

void main()
{
	File("day07.in", "r")
		.readln
		.split(",")
		.map!(to!int)
		.array
		.calcFuelCost
		.writeln;
}

int calcFuelCost(in int[] positions)
{
	return positions.map!(
		(pos) => reduce!(
			(cost, other) => cost + abs(pos - other))(0, positions)
	).minElement;
}

unittest
{
	const positions = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14];
	const cost = positions.calcFuelCost;
	assert(cost == 37, format!"Expected %s, received: %s"(37, cost));
}

import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.range;
import std.stdio;
import std.string;

void main()
{
	const positions = File("day07.in", "r")
		.readln
		.split(",")
		.map!(to!int)
		.array;

	positions.calcFuelCost(&constantCost)
		.writeln;
	positions.calcFuelCost(&exponCost)
		.writeln;
}

int calcFuelCost(in int[] positions, int function(int, int) costFunc)
{
	return iota(positions.minElement, positions.maxElement).map!(
		(pos) => reduce!(
			(cost, other) => costFunc(cost, abs(pos - other)))(0, positions)
	).minElement;
}

int constantCost(int cost, int distance)
{
	return cost + distance;
}

int exponCost(int cost, int distance)
{
	return cost + to!int(
		distance * (distance + 1) * 0.5);
}

unittest
{
	const positions = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14];
	const constantCost = positions.calcFuelCost(
		&constantCost);
	assert(constantCost == 37, format!"Expected %s, received: %s"(37, constantCost));
	const exponCost = positions.calcFuelCost(&exponCost);
	assert(exponCost == 168, format!"Expected %s, received: %s"(
			168, exponCost));
}

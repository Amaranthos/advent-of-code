import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

void main()
{
	const depths = File("day01.in", "r").byLine.map!(to!uint).array;
	depths.countPairsIncreasing.writeln;
	depths.countTripletsIncreasing.writeln;
}

uint countPairsIncreasing(in uint[] depths)
{
	return depths.slide(2)
		.map!(a => a[0] < a[1] ? 1 : 0)
		.reduce!"a + b";
}

unittest
{
	const uint[] depths = [
		199, 200, 208, 210, 200, 207, 240, 269, 260, 263
	];
	const count = countPairsIncreasing(depths);
	assert(count == 7, format!"Expected 7, received: %s"(count));
}

uint countTripletsIncreasing(in uint[] depths)
{
	return depths.slide(3)
		.map!(a => a[0] + a[1] + a[2])
		.slide(2)
		.map!(a => a[0] < a[1] ? 1 : 0)
		.reduce!"a + b";
}

unittest
{
	const uint[] depths = [
		199, 200, 208, 210, 200, 207, 240, 269, 260, 263
	];
	const count = countTripletsIncreasing(depths);
	assert(count == 5, format!"Expected 5, received: %s"(count));
}

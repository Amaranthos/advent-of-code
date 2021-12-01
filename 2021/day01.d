import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

void main()
{
	File("day01.in", "r").byLine.map!(to!uint).array.countDepthIncreased.writeln;
}

uint countDepthIncreased(in uint[] depths)
{
	return zip(depths, depths
			.dropOne).map!(a => a[0] < a[1])
		.map!(to!uint)
		.reduce!"a + b";
}

unittest
{
	const uint[] depths = [
		199, 200, 208, 210, 200, 207, 240, 269, 260, 263
	];

	const count = countDepthIncreased(depths);

	assert(count == 7, format!"Expected 7, received: %s"(count));
}

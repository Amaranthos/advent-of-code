module day02;

import std.array;
import std.algorithm;
import std.conv;
import std.stdio;
import std.string;
import std.typecons;

void main()
{
	const commands = File("day02.in", "r").byLine
		.map!split
		.map!(a => Command(to!string(a[0]), to!int(a[1])))
		.array;
	const position = commands.determinePosition;

	writefln!"%s, %s"(position, position[0] * position[1]);
}

alias Command = Tuple!(string, int);

Tuple!(int, int) determinePosition(in Command[] commands)
{
	Tuple!(int, int) position;
	foreach (command; commands)
	{
		switch (command[0])
		{
		case "forward":
			position[0] += command[1];
			continue;
		case "down":
			position[1] += command[1];
			continue;
		case "up":
			position[1] -= command[1];
			continue;
		default:
			assert(false, format!"Received command %s"(command[0]));
		}
	}
	return position;
}

unittest
{
	const Command[] commands = [
		tuple("forward", 5), tuple("down", 5), tuple("forward", 8),
		tuple("up", 3),
		tuple("down", 8), tuple("forward", 2)
	];

	const pos = determinePosition(commands);

	assert(pos[0] == 15, format!"Expected 15, received: %s"(pos[0]));
	assert(pos[1] == 10, format!"Expected 15, received: %s"(pos[1]));
}

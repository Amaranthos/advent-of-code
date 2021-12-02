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
alias Position = Tuple!(int, "x", int, "depth", int, "aim");

Position determinePosition(in Command[] commands)
{
	Position position;
	foreach (command; commands)
	{
		switch (command[0])
		{
		case "forward":
			position.x += command[1];
			position.depth += (position.aim * command[1]);
			continue;
		case "down":
			position.aim += command[1];
			continue;
		case "up":
			position.aim -= command[1];
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
		Command("forward", 5), Command("down", 5), Command("forward", 8),
		Command("up", 3),
		Command("down", 8), Command("forward", 2)
	];

	const pos = determinePosition(commands);

	assert(pos.x == 15, format!"Expected 15, received: %s"(pos[0]));
	assert(pos.depth == 60, format!"Expected 60, received: %s"(pos[1]));
	assert(pos.aim == 10, format!"Expected 10, received: %s"(pos[1]));
}

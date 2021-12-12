module day11;

import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;
import std.typecons;

const ANSI_OFFSET = 48;

void main()
{
	File("day11.in", "r")
		.byLine
		.map!(to!string)
		.array
		.countFlashes(100)
		.writeln;
}

alias Coord = Tuple!(const ulong, const ulong);
alias Octo = Tuple!(int, bool);
int countFlashes(in string[] octi, in int steps)
{
	int count;
	Octo[][] cells = octi.map!(row => row.map!(d => tuple(d.to!int - ANSI_OFFSET, false)).array)
		.array;
	const rows = octi.length;
	const cols = octi[0].length;

	Coord[] getNeighbours(in ulong rowIdx, in ulong colIdx)
	{
		Coord[] neighbours;
		foreach (row; -1 .. 2)
		{
			const ny = rowIdx + row;
			foreach (col; -1 .. 2)
			{
				const nx = colIdx + col;
				if (row == 0 && col == 0)
					continue;

				if (ny < 0 || ny >= rows)
					continue;
				if (nx < 0 || nx >= cols)
					continue;

				neighbours ~= tuple(nx, ny);
			}
		}
		return neighbours;
	}

	foreach (step; 0 .. steps)
	{
		// Increment
		foreach (ref row; cells)
		{
			foreach (ref octopus; row)
			{
				++octopus[0];
			}
		}

		// Check for flashes
		Coord[] stack;
		foreach (y, row; cells)
		{
			foreach (x, ref octopus; row)
			{
				if (octopus[0] > 9)
				{
					octopus[1] = true;
					stack ~= getNeighbours(y, x);
				}
			}
		}

		while (!stack.empty)
		{
			auto coords = stack.back;
			stack.popBack;

			auto octo = &cells[coords[1]][coords[0]];

			++((*octo)[0]);
			if ((*octo)[0] > 9 && !(*octo)[1])
			{
				(*octo)[1] = true;
				stack ~= getNeighbours(coords[1], coords[0]);
			}
		}

		// Reset levels
		foreach (row; cells)
		{
			foreach (ref octopus; row)
			{
				octopus[1] = false;
				if (octopus[0] > 9)
				{
					++count;
					octopus[0] = 0;
				}
			}
		}
	}

	return count;
}

unittest
{
	// const octi = [
	// 	"11111",
	// 	"19991",
	// 	"19191",
	// 	"19991",
	// 	"11111",
	// ];

	const octi = [
		"5483143223",
		"2745854711",
		"5264556173",
		"6141336146",
		"6357385478",
		"4167524645",
		"2176841721",
		"6882881134",
		"4846848554",
		"5283751526",
	];

	const count10 = countFlashes(octi, 10);
	assert(count10 == 204, format!"Expected %s, received: %s"(204, count10));

	const count100 = countFlashes(octi, 100);
	assert(count100 == 1656, format!"Expected %s, received: %s"(1656, count100));
}

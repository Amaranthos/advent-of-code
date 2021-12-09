import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

const ANSI_OFFSET = 48;

void main()
{
	const heightMap = File("day09.in", "r").byLine
		.map!(line => line.map!(d => (d.to!int - ANSI_OFFSET)).array)
		.array;

	heightMap.lowPoints
		.riskFactor
		.writeln;

	heightMap.basins.sort!"a>b"[0 .. 3].reduce!((product, value) => product * value).writeln;
}

alias Pos = Tuple!(ulong, "x", ulong, "y");

Pos[] lowPointCoords(in int[][] heightMap)
{
	Pos[] lowPoints;
	foreach (y, row; heightMap)
	{
		foreach (x, tile; row)
		{
			bool lowest = true;

			const t = [to!long(x), to!long(y) - 1];
			const b = [to!long(x), to!long(y) + 1];
			const l = [to!long(x) - 1, to!long(y)];
			const r = [to!long(x) + 1, to!long(y)];

			foreach (neighbour; [t, b, l, r])
			{
				const nx = neighbour[0];
				const ny = neighbour[1];
				if (ny >= 0 && ny < heightMap.length)
				{
					if (nx >= 0 && nx < row.length)
					{
						lowest &= tile < heightMap[ny][nx];
					}
				}
			}

			if (lowest)
			{
				lowPoints ~= Pos(x, y);
			}
		}
	}
	return lowPoints;
}

const(int[]) lowPoints(in int[][] heightMap)
{
	return heightMap
		.lowPointCoords
		.map!(coords => heightMap[coords[1]][coords[0]])
		.array;
}

unittest
{
	const heightmap = [
		[2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
		[3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
		[9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
		[8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
		[9, 8, 9, 9, 9, 6, 5, 6, 7, 8],
	];

	const lowPoints = heightmap.lowPoints;

	assert(lowPoints == [1, 0, 5, 5], format!"Expected %s, received: %s"([
			1, 0, 5, 5
		], lowPoints));
}

int riskFactor(in int[] lowPoints)
{
	return lowPoints.map!(lp => lp + 1)
		.sum;
}

unittest
{
	const riskFactor = [1, 0, 5, 5].riskFactor;

	assert(riskFactor == 15, format!"Expected %s, received: %s"(15, riskFactor));
}

ulong[] basins(in int[][] heightMap)
{
	ulong[] basins;

	const rows = heightMap.length;
	const cols = heightMap[0].length;

	foreach (lp; heightMap.lowPointCoords)
	{
		Pos[] stack = [lp];
		Pos[] visited = [];

		while (!stack.empty)
		{
			const pos = stack.back;
			stack.popBack;

			const t = [to!long(pos.x), to!long(pos.y) - 1];
			const b = [to!long(pos.x), to!long(pos.y) + 1];
			const l = [to!long(pos.x) - 1, to!long(pos.y)];
			const r = [to!long(pos.x) + 1, to!long(pos.y)];

			foreach (neighbour; [t, b, l, r])
			{
				const nx = neighbour[0];
				const ny = neighbour[1];
				if (ny >= 0 && ny < rows)
				{
					if (nx >= 0 && nx < cols)
					{
						if (heightMap[ny][nx] != 9)
						{
							const nPos = Pos(nx, ny);
							if (!visited.canFind(nPos))
							{
								stack ~= nPos;
								visited ~= nPos;
							}
						}
					}
				}
			}
		}

		basins ~= visited.length;
	}
	return basins;
}

unittest
{
	const heightmap = [
		[2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
		[3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
		[9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
		[8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
		[9, 8, 9, 9, 9, 6, 5, 6, 7, 8],
	];

	const basins = heightmap.basins;

	assert(basins == [3, 9, 14, 9], format!"Expected %s, received: %s"([
			3, 9, 14, 9
		], basins));
}

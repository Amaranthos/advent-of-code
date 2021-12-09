import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;
import std.string;

const ANSI_OFFSET = 48;

void main()
{
	File("day09.in", "r").byLine
		.map!(line => line.map!(d => (d.to!int - ANSI_OFFSET)).array)
		.array
		.lowPoints
		.riskFactor
		.writeln;
}

int[] lowPoints(in int[][] heightMap)
{
	int[] lowPoints;
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
				lowPoints ~= [tile];
			}
		}
	}
	return lowPoints;
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

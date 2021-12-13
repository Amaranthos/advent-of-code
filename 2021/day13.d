import std.algorithm;
import std.array;
import std.conv;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

const folds = [
	tuple("x", 655),
	tuple("y", 447),
	tuple("x", 327),
	tuple("y", 223),
	tuple("x", 163),
	tuple("y", 111),
	tuple("x", 81),
	tuple("y", 55),
	tuple("x", 40),
	tuple("y", 27),
	tuple("y", 13),
	tuple("y", 6),
];

void main()
{
	File("day13.in", "r")
		.byLine
		.map!((l) => l
				.split(",")
				.map!(to!int)
				.array)
		.array
		.fold(folds, folds.length);
}

void fold(int[][] dots, in Tuple!(string, int)[] folds, ulong numFolds)
{
	bool[][] map = new bool[][](
		dots.map!(d => d[1]).maxElement + 1,
		dots.map!(d => d[0]).maxElement + 1
	);

	foreach (dot; dots)
	{
		map[dot[1]][dot[0]] = true;
	}

	foreach (idx, fold; folds[0 .. numFolds])
	{
		const ulong value = fold[1];
		switch (fold[0])
		{
		case "y":
			foreach (y; 0 .. value)
			{
				foreach (x; 0 .. map[y].length)
				{
					if (2 * value - y < map.length)
					{
						map[y][x] |= map[(2 * value) - y][x];
					}
				}
			}
			map.length = value;
			break;

		case "x":
			foreach (y; 0 .. map.length)
			{
				foreach (x; 0 .. value)
				{
					map[y][x] |= map[y][(2 * value) - x];
				}
				map[y].length = value;
			}
			break;

		default:
			assert(false, fold[0]);
		}

		if (idx == 0)
		{
			int count;
			foreach (row; map)
			{
				foreach (cell; row)
				{
					count += cell ? 1 : 0;
				}
			}
			count.writeln;
		}
	}

	writeln;
	foreach (row; map)
	{
		foreach (cell; row)
		{
			write(cell ? "█" : "░");
		}
		writeln;
	}
}

unittest
{
	const count = fold([
		[6, 10],
		[0, 14],
		[9, 10],
		[0, 3],
		[10, 4],
		[4, 11],
		[6, 0],
		[6, 12],
		[4, 1],
		[0, 13],
		[10, 12],
		[3, 4],
		[3, 0],
		[8, 4],
		[1, 10],
		[2, 14],
		[8, 10],
		[9, 0],
	], [tuple("y", 7), tuple("x", 5)], 2);

	assert(count == 16, format!"Expected %s, received: %s"(16, count));
}

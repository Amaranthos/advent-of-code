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
		.fold(folds, 1)
		.writeln;
}

int fold(int[][] dots, in Tuple!(string, int)[] folds, int numFolds)
{
	const initCols = dots.map!(d => d[0]).maxElement + 1;
	uint cols = initCols;
	uint rows = dots.map!(d => d[1]).maxElement + 1;

	bool[] map = new bool[](rows * cols);

	foreach (dot; dots)
	{
		map[dot[1] * cols + dot[0]] = true;
	}

	foreach (fold; folds[0 .. numFolds])
	{
		switch (fold[0])
		{
		case "x":
			const col = fold[1];
			foreach (y; 0 .. rows)
			{
				foreach (x; 0 .. col)
				{
					map[y * initCols + x] |= map[y * initCols + (cols - 1 - x)];
				}
			}
			cols = col;
			break;

		case "y":
			const row = fold[1];
			foreach (y; 0 .. row)
			{
				foreach (x; 0 .. cols)
				{
					map[y * cols + x] |= map[(
							rows - 1 - y) * cols + x];
				}
			}
			rows = row;
			break;

		default:
			assert(false, fold[0]);
		}

		version (unittest)
		{
			writeln;
			foreach (y; 0 .. rows)
			{
				foreach (x; 0 .. cols)
				{
					write(map[y * initCols + x] ? "#" : ".");
				}
				writeln;
			}
		}
	}

	int count;
	foreach (y; 0 .. rows)
	{
		foreach (x; 0 .. cols)
		{
			count += map[y * initCols + x] ? 1 : 0;
		}
	}

	return count;
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

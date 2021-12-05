import std.algorithm;
import std.array;
import std.conv;
import std.regex;
import std.stdio;
import std.typecons;

void main()
{
	const matcher = ctRegex!(r"^(\d+),(\d+) -> (\d+),(\d+)$");
	const segments = File("day05.in", "r").byLine
		.map!(line => matchFirst(line, matcher))
		.map!(match => [match[1], match[2], match[3], match[4]].map!(to!int))
		.map!(ints => Segment([ints[0], ints[1]], [ints[2], ints[3]]))
		.array;

	segments.buildField.countOverlaps.writeln;
}

alias Point = int[2];
alias Segment = Tuple!(Point, "start", Point, "end");

Point[] getPoints(in Segment segment)
{
	const x1 = min(segment.start[0], segment.end[0]);
	const x2 = max(segment.start[0], segment.end[0]) + 1;
	const y1 = min(segment.start[1], segment.end[1]);
	const y2 = max(segment.start[1], segment.end[1]) + 1;

	Point[] points;
	foreach (col; x1 .. x2)
	{
		foreach (row; y1 .. y2)
		{
			points ~= [col, row];
		}
	}

	return points;
}

unittest
{
	const segment1 = Segment([1, 1], [1, 3]);
	const segment2 = Segment([9, 7], [7, 7]);

	assert(segment1.getPoints.equal([
				[1, 1], [1, 2], [1, 3]
			]));

	assert(segment2.getPoints.equal([
				[7, 7], [8, 7], [9, 7]
			]));
}

int[][] buildField(in Segment[] segments)
{
	int cols;
	int rows;
	foreach (Segment segment; segments)
	{
		cols = max(cols, segment.start[0], segment.end[0]);
		rows = max(rows, segment.start[1], segment.end[1]);
	}

	int[][] field = new int[][](cols + 1, rows + 1);
	foreach (Segment segment; segments)
	{
		if (segment.start[0] != segment.end[0] && segment.start[1] != segment.end[1])
			continue;

		foreach (Point point; segment.getPoints)
		{
			++field[point[1]][point[0]];
		}
	}

	return field;
}

int countOverlaps(in int[][] field)
{
	int count;
	foreach (row; field)
	{
		foreach (cell; row)
		{
			if (cell >= 2)
			{
				++count;
			}
		}
	}
	return count;
}

unittest
{
	const segments = [
		Segment([0, 9], [5, 9]),
		Segment([8, 0], [0, 8]),
		Segment([9, 4], [3, 4]),
		Segment([2, 2], [2, 1]),
		Segment([7, 0], [7, 4]),
		Segment([6, 4], [2, 0]),
		Segment([0, 9], [2, 9]),
		Segment([3, 4], [1, 4]),
		Segment([0, 0], [8, 8]),
		Segment([5, 5], [8, 2]),
	];

	const field = buildField(segments);

	assert(field.countOverlaps == 5);
}

import std.array;
import std.range;
import std.stdio;

void main()
{
	// const file = File("day03.input").byLineCopy().array;
	writeln(File("day03.input").byLineCopy().array.parseToGrid.route);
}

struct Grid
{
	ulong width;
	ulong height;
	string cells;
}

Grid parseToGrid(const string[] lines)
{
	return Grid(lines[0].length, lines.length, lines.join(""));
}

unittest
{
	// dfmt off
	const string chunk = 
"..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#";
// dfmt on

	assert(parseToGrid(chunk.split("\n")) == Grid(11, 11, "..##.......#...#...#...#....#..#...#.#...#.#.#...##..#...#.##......#.#.#....#.#........##.##...#...#...##....#.#..#...#.#"));
}

uint route(const Grid grid)
{
	uint row = 0;
	uint column = 0;
	uint count = 0;

	const stepRight = 3;
	const stepDown = 1;

	while (row < grid.height)
	{
		const cell = grid.cells[column % grid.width + row * grid.width];
		if (cell == '#')
			count++;

		column += stepRight;
		row += stepDown;
	}

	return count;
}

unittest
{
	Grid grid = Grid(11, 11, "..##.......#...#...#...#....#..#...#.#...#.#.#...##..#...#.##......#.#.#....#.#........##.##...#...#...##....#.#..#...#.#");

	assert(grid.route == 7);
}

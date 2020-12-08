import std.algorithm;
import std.array;
import std.range;
import std.stdio;
import std.typecons;

void main()
{
	const grid = File("day03.input").byLineCopy().array.parseToGrid;
	// dfmt off
	writeln([
		grid.route!(1, 1), 
		grid.route!(3, 1), 
		grid.route!(5, 1), 
		grid.route!(7, 1), 
		grid.route!(1, 2), 
	].reduce!((a, b) => a * b));
	// dfmt on
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

uint route(uint r, uint d)(const Grid grid)
{
	uint row = 0;
	uint column = 0;
	uint count = 0;

	while (row < grid.height)
	{
		const cell = grid.cells[column % grid.width + row * grid.width];
		if (cell == '#')
			count++;

		column += r;
		row += d;
	}

	return count;
}

unittest
{
	Grid grid = Grid(11, 11, "..##.......#...#...#...#....#..#...#.#...#.#.#...##..#...#.##......#.#.#....#.#........##.##...#...#...##....#.#..#...#.#");

	assert(grid.route!(1, 1) == 2);
	assert(grid.route!(3, 1) == 7);
	assert(grid.route!(5, 1) == 3);
	assert(grid.route!(7, 1) == 4);
	assert(grid.route!(1, 2) == 2);
}

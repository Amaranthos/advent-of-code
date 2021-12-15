import std.algorithm;
import std.array;
import std.container;
import std.conv;
import std.stdio;
import std.string;
import std.typecons;

const ANSI_OFFSET = 48;

void main()
{
	const tiles = File("day15.in", "r")
		.byLine
		.map!(line => line.map!(d => (d.to!int - ANSI_OFFSET)).array)
		.array;

	reduce!((cost, tile) => cost + tiles[tile.y][tile.x])(0, tiles.findShortestPath).writeln;
}

unittest
{
	const tiles = [
		[1, 1, 6, 3, 7, 5, 1, 7, 4, 2],
		[1, 3, 8, 1, 3, 7, 3, 6, 7, 2],
		[2, 1, 3, 6, 5, 1, 1, 3, 2, 8],
		[3, 6, 9, 4, 9, 3, 1, 5, 6, 9],
		[7, 4, 6, 3, 4, 1, 7, 1, 1, 1],
		[1, 3, 1, 9, 1, 2, 8, 1, 3, 7],
		[1, 3, 5, 9, 9, 1, 2, 4, 2, 1],
		[3, 1, 2, 5, 4, 2, 1, 6, 3, 9],
		[1, 2, 9, 3, 1, 3, 8, 5, 2, 1],
		[2, 3, 1, 1, 9, 4, 4, 5, 8, 1],
	];

	assert(reduce!((cost, tile) => cost + tiles[tile.y][tile.x])(0, tiles.findShortestPath) == 40);
}

alias Tile = Tuple!(ulong, "x", ulong, "y");

Tile[] findShortestPath(in int[][] tiles)
{
	const rows = tiles.length;
	const cols = tiles[0].length;
	const start = Tile(0, 0);
	const goal = Tile(cols - 1, rows - 1);

	auto queue = DList!Tile(start);
	Tile[Tile] cameFrom;
	int[Tile] costSoFar;

	while (!queue.empty)
	{
		auto current = queue.front;
		queue.removeFront;

		if (current == goal)
		{
			break;
		}

		foreach (neighbour; current.neighbours(tiles))
		{
			int cost = tiles[neighbour.y][neighbour.x];
			if (current in costSoFar)
			{
				cost += costSoFar[current];
			}

			if (neighbour !in costSoFar || cost < costSoFar[neighbour])
			{
				costSoFar[neighbour] = cost;
				cameFrom[neighbour] = current;
				queue.insertBack(neighbour);
			}
		}
	}

	Tile current = goal;
	Tile[] path;
	while (current != start)
	{
		path ~= current;
		current = cameFrom[current];
	}
	path.reverse;

	return path;
}

Tile[] neighbours(in Tile current, in int[][] tiles)
{
	Tile[] neighbours;

	const t = Tile(current.x, current.y - 1);
	const b = Tile(current.x, current.y + 1);
	const l = Tile(current.x - 1, current.y);
	const r = Tile(current.x + 1, current.y);

	foreach (coord; [t, b, l, r])
	{
		const nx = coord[0];
		const ny = coord[1];
		if (ny >= 0 && ny < tiles.length)
		{
			if (nx >= 0 && nx < tiles[0].length)
			{
				neighbours ~= coord;
			}
		}
	}

	return neighbours;
}

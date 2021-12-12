module day12;

import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;

void main()
{
	File("day12.in", "r")
		.byLine
		.map!(to!string)
		.array
		.buildGraph
		.find(["start"])
		.writeln;
}

Cave[const(string)] buildGraph(in string[] map)
{
	Cave[const(string)] graph;

	foreach (row; map)
	{
		auto parts = row.split("-");

		if (!(parts[0] in graph))
		{
			graph[parts[0]] = new Cave();
		}
		Cave cave = graph[parts[0]];

		if (!(parts[1] in graph))
		{
			graph[parts[1]] = new Cave();
		}
		Cave other = graph[parts[1]];

		cave.linked[parts[1]] = other;
		other.linked[parts[0]] = cave;
	}

	return graph;
}

int find(in Cave[const(string)] graph, string[] path)
{
	string current = path[$ - 1];
	if (current == "end")
	{
		return 1;
	}

	int count;
	foreach (name, cave; graph[current].linked)
	{
		if (name.toUpper == name || !path.canFind(name))
		{
			count += find(graph, path ~ [name]);
		}
	}
	return count;
}

unittest
{
	auto graph = buildGraph([
		"start-A",
		"start-b",
		"A-c",
		"A-b",
		"b-d",
		"A-end",
		"b-end"
	]);

	assert(graph.length == 6);
	assert(find(graph, ["start"]) == 10);
}

class Cave
{
	Cave[const(string)] linked;
}

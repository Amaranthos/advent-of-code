import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.stdio;

void main()
{
	readText("day08.input").parseOperations.tryExecute.writeln;
}

struct Operation
{
	string instruction;
	int argument;
	bool executed;
}

Operation[] parseOperations(in string data)
{
	// dfmt off
	return data
		.splitter("\n")
		.map!(a => a.splitter(" ").array)
		.map!(a => Operation(a[0], a[1].to!int, false))
		.array;
	 // dfmt on
}

int tryExecute(Operation[] ops)
{
	uint index = 0;
	uint acc = 0;

	while (true)
	{
		auto op = &ops[index];

		if (op.executed)
		{
			break;
		}

		final switch (op.instruction)
		{
		case "nop":
			++index;
			break;
		case "acc":
			acc += op.argument;
			++index;
			break;
		case "jmp":
			index += op.argument;
			break;
		}

		op.executed = true;
	}

	return acc;
}

unittest
{
	const data = `nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6`;

	auto ops = data.parseOperations;

	assert(ops.length == 9);
	assert(ops.tryExecute == 5);
}

import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.stdio;
import std.typecons;

void main()
{
	readText("day08.input").parseOperations.tryExecute.writeln;
	readText("day08.input").parseOperations.fixExecute.writeln;
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

Tuple!(int, bool) tryExecute(Operation[] ops)
{
	uint index = 0;
	int acc = 0;
	bool didNotLoop = true;

	while (index < ops.length)
	{
		auto op = &ops[index];

		if (op.executed)
		{
			didNotLoop = false;
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

	return tuple(acc, didNotLoop);
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
	assert(ops.tryExecute == tuple(5, false));
}

int fixExecute(Operation[] ops)
{
	uint idx = 0;
	auto results = ops.dup.tryExecute;
	do
	{
		auto copiedOps = ops.dup;
		auto op = &copiedOps[idx];

		switch (op.instruction)
		{
		case "nop":
			op.instruction = "jmp";
			break;

		case "jmp":
			op.instruction = "nop";
			break;

		default:
			break;
		}

		results = copiedOps.tryExecute;
		++idx;
	}
	while (idx < ops.length && !results[1]);

	return results[0];
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

	assert(data.parseOperations.fixExecute == 8);
}

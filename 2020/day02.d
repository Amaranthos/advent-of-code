import std.array;
import std.conv;
import std.range;
import std.regex;
import std.stdio;
import std.string;

void main()
{
	uint count = 0;
	foreach (entry; File("day02.input", "r").byLineCopy())
	{
		auto ss = split(entry, ": ");
		Policy policy = parsePolicy(ss[0]);
		if (policy.isValid(ss[1]))
		{
			count++;
		}
	}

	count.writeln;
}

struct Policy
{
	int posAllowed;
	int posDisallowed;
	char character;
}

Policy parsePolicy(string input)
{
	auto ss = split(input, regex(`-| `));
	return Policy(parse!int(ss[0]), parse!int(ss[1]), ss[2][0]);
}

unittest
{
	assert(parsePolicy("1-3 a") == Policy(1, 3, 'a'));
	assert(parsePolicy("1-3 b") == Policy(1, 3, 'b'));
	assert(parsePolicy("2-9 c") == Policy(2, 9, 'c'));
}

bool isValid(Policy policy, string password)
{
	const pos1 = password[policy.posAllowed - 1] == policy.character;
	const pos2 = password[policy.posDisallowed - 1] == policy.character;

	return pos1 ^ pos2;
}

unittest
{
	assert(isValid(Policy(1, 3, 'a'), "abcde"));
	assert(!isValid(Policy(1, 3, 'b'), "cdefg"));
	assert(!isValid(Policy(2, 9, 'c'), "ccccccccc"));
}

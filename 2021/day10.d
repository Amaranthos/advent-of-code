import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;

void main()
{
	File("day10.in", "r")
		.byLine
		.map!(to!string)
		.array
		.scoreCorrupted
		.writeln;
}

const char[char] chunkOpen;
int[char] chunkClose;
static this()
{
	chunkOpen['('] = ')';
	chunkOpen['['] = ']';
	chunkOpen['{'] = '}';
	chunkOpen['<'] = '>';

	chunkClose[')'] = 3;
	chunkClose[']'] = 57;
	chunkClose['}'] = 1197;
	chunkClose['>'] = 25_137;

}

char getCorrupted(in string line)
{
	char[] stack;

	foreach (character; line)
	{
		if (character in chunkOpen)
		{
			stack ~= character;
		}
		else if (character in chunkClose)
		{
			char opening = stack[$ - 1];
			stack.popBack;

			if (chunkOpen[opening] != character)
			{
				return character;
			}
		}
		else
		{
			// NOOP
		}
	}

	return '\0';
}

unittest
{
	assert(!"([])".getCorrupted);
	assert("(]".getCorrupted);
	assert("{()()()>".getCorrupted);
	assert("(((()))}".getCorrupted);
	assert("<([]){()}[{}])".getCorrupted);

	assert("{([(<{}[<>[]}>{[]{[(<()>".getCorrupted == '}');
	assert("[[<[([]))<([[{}[[()]]]".getCorrupted == ')');
	assert("[{[{({}]{}}([{[{{{}}([]".getCorrupted == ']');
	assert("[<(<(<(<{}))><([]([]()".getCorrupted == ')');
	assert("<{([([[(<>()){}]>(<<{{ ".getCorrupted == '>');
}

int scoreCorrupted(in string[] lines)
{
	return lines
		.map!(getCorrupted)
		.filter!(c => c != '\0')
		.map!((c) => chunkClose[c])
		.sum;
}

unittest
{
	const lines = `[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]`.split;

	const score = lines.scoreCorrupted;

	assert(score == 26_397, format!"Expected %s, received: %s"(26_397, score));

}

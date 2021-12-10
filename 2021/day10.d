import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;
import std.range;

void main()
{
	const lines = File("day10.in", "r")
		.byLine
		.map!(to!string)
		.array;

	lines
		.scoreCorrupted
		.writeln;

	lines
		.filter!(l => !getCorrupted(l))
		.map!(fixLine)
		.array
		.sort[$ / 2]
		.writeln;
}

const char[char] chunkOpen;
int[char] chunkClose;
int[char] fixScore;
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

	fixScore[')'] = 1;
	fixScore[']'] = 2;
	fixScore['}'] = 3;
	fixScore['>'] = 4;

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
			const char opening = stack[$ - 1];
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

long fixLine(in string line)
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
			const char opening = stack[$ - 1];
			stack.popBack;
			assert(chunkOpen[opening] == character);
		}
		else
		{
			// NOOP
		}
	}

	long score;
	while (!stack.empty)
	{
		const char opening = stack[$ - 1];
		stack.popBack;
		const closing = chunkOpen[opening];

		score *= 5;
		score += fixScore[closing];
	}

	return score;
}

unittest
{
	const line1 = "[({(<(())[]>[[{[]{<()<>>";
	const score1 = line1.fixLine;
	assert(score1 == 288_957, format!"Expected %s, received: %s"(288_957, score1));

	const line2 = "[(()[<>])]({[<{<<[]>>(";
	const score2 = line2.fixLine;
	assert(score2 == 5566, format!"Expected %s, received: %s"(5566, score2));

	const line3 = "(((({<>}<{<{<>}{[]{[]{}";
	const score3 = line3.fixLine;
	assert(score3 == 1_480_781, format!"Expected %s, received: %s"(1_480_781, score3));

	const line4 = "{<[[]]>}<{[{[{[]{()[[[]";
	const score4 = line4.fixLine;
	assert(score4 == 995_444, format!"Expected %s, received: %s"(995_444, score4));

	const line5 = "<{([{{}}[<[[[<>{}]]]>[]]";
	const score5 = line5.fixLine;
	assert(score5 == 294, format!"Expected %s, received: %s"(294, score5));

	const lines = `[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
(((({<>}<{<{<>}{[]{[]{}
{<[[]]>}<{[{[{[]{()[[[]
<{([{{}}[<[[[<>{}]]]>[]]`.split;

	assert(lines
			.map!(fixLine)
			.array
			.sort[$ / 2] == 288_957);
}

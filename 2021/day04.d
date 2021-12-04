import std.algorithm;
import std.conv;
import std.range;
import std.stdio;
import std.typecons;

const input = [
	28, 82, 77, 88, 95, 55, 62, 21, 99, 14, 30, 9, 97, 92, 94, 3, 60, 22, 18,
	86,
	78, 71, 61, 43, 79, 33, 65, 81, 26, 49, 47, 51, 0, 89, 57, 75, 42, 35, 80,
	1,
	46, 83, 39, 53, 40, 36, 54, 70, 76, 38, 50, 23, 67, 2, 20, 87, 37, 66, 84,
	24,
	98, 4, 7, 12, 44, 10, 29, 5, 48, 59, 32, 41, 90, 17, 56, 85, 96, 93, 27,
	74,
	45, 25, 15, 6, 69, 16, 19, 8, 31, 13, 64, 63, 34, 73, 58, 91, 11, 68, 72,
	52
];

void main()
{
	File file = File("day04.in", "r");

	Board[] boards;

	while (!file.eof)
	{

		int[][] read;
		foreach (line; file.byLine().take(5))
		{
			read ~= line.split.map!(to!int).array;
		}
		boards ~= Board(read);
		file.readln();
	}

	// Part A
	playGame(input, boards.dup).writeln;

	// Part B
	playUntilLastGame(input, boards.dup).writeln;
}

struct Board
{
	Tuple!(int, "number", bool, "marked")[5][5] board;
	bool won = false;

	this(int[][] input)
	{
		foreach (y, row; input)
		{
			foreach (x, cell; row)
			{
				this.board[y][x] = tuple(cell, false);
			}
		}
	}

	void playDrawn(int drawn)
	{
		foreach (y, ref row; board)
		{
			foreach (x, ref cell; row)
			{
				if (cell.number == drawn)
					cell.marked = true;
			}
		}
	}

	unittest
	{
		Board b = Board([
			[22, 13, 17, 11, 0],
			[8, 2, 23, 4, 24],
			[21, 9, 14, 16, 7],
			[6, 10, 3, 18, 5],
			[1, 12, 20, 15, 19]
		]);

		b.playDrawn(7);

		assert(b.board[2][4].marked);
	}

	bool checkForWin()
	{
		bool result = false;

		// Check for rows
		foreach (row; board)
		{
			bool marked = true;
			foreach (cell; row)
			{
				marked &= cell.marked;
			}

			if (marked)
			{
				result = true;
			}
		}

		// Check columns
		foreach (col; 0 .. 5)
		{
			bool marked = true;
			foreach (row; 0 .. 5)
			{
				marked &= board[row][col].marked;
			}

			if (marked)
			{
				result = true;
			}
		}

		if (result)
			won = true;

		return result;
	}

	unittest
	{
		Board b = Board([
			[14, 21, 17, 24, 4],
			[10, 16, 15, 9, 19],
			[18, 8, 23, 26, 20],
			[22, 11, 13, 6, 5],
			[2, 0, 12, 3, 7],
		]);

		foreach (drawn; [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24])
		{
			b.playDrawn(drawn);
		}

		assert(b.checkForWin);
	}

	unittest
	{
		Board b = Board([
			[14, 10, 18, 22, 2],
			[21, 16, 8, 11, 0],
			[17, 15, 23, 13, 12],
			[24, 9, 26, 6, 3,],
			[4, 19, 20, 5, 7]
		]);

		foreach (drawn; [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24])
		{
			b.playDrawn(drawn);
		}

		assert(b.checkForWin);
	}

	int score(int drawn)
	{
		int sum = 0;
		foreach (row; board)
		{
			foreach (cell; row)
			{
				if (!cell.marked)
					sum += cell.number;
			}
		}

		return sum * drawn;
	}

	unittest
	{
		Board b = Board([
			[14, 21, 17, 24, 4],
			[10, 16, 15, 9, 19],
			[18, 8, 23, 26, 20],
			[22, 11, 13, 6, 5],
			[2, 0, 12, 3, 7],
		]);

		foreach (drawn; [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24])
		{
			b.playDrawn(drawn);
		}

		assert(b.score(24) == 4512);
	}

	string toString() const
	{
		import std.string : format;

		string print = "[\n";

		foreach (row; board)
		{
			foreach (cell; row)
			{
				print ~= format!"%.2s%s "(cell.number, cell.marked ? 'T' : 'F');
			}
			print ~= "\n";
		}

		print ~= ']';

		return print;
	}
}

alias Result = Tuple!(int, "score", int, "drawn");

int playRound(int drawn, ref Board[] boards)
{
	foreach (ref board; boards)
	{
		if (board.won)
			continue;
		board.playDrawn(drawn);
		if (board.checkForWin())
		{
			return board.score(drawn);
		}
	}
	return 0;
}

Result playGame(in int[] numbers, Board[] boards)
{
	int score = 0;
	foreach (drawn; numbers)
	{
		score = playRound(drawn, boards);
		if (score)
			return Result(score, drawn);
	}

	return Result(0, 0);
}

unittest
{
	Board[] boards = [
		Board([
			[22, 13, 17, 11, 0],
			[8, 2, 23, 4, 24],
			[21, 9, 14, 16, 7],
			[6, 10, 3, 18, 5],
			[1, 12, 20, 15, 19]
		]),
		Board([
			[3, 15, 0, 2, 22],
			[9, 18, 13, 17, 5],
			[19, 8, 7, 25, 23],
			[20, 11, 10, 24, 4],
			[14, 21, 16, 12, 6],
		]),
		Board([
			[14, 21, 17, 24, 4],
			[10, 16, 15, 9, 19],
			[18, 8, 23, 26, 20],
			[22, 11, 13, 6, 5],
			[2, 0, 12, 3, 7],
		])
	];

	const result = playGame([
		7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12,
		22, 18, 20, 8, 19, 3, 26, 1
	], boards);

	import std.string : format;

	assert(result.drawn == 24, format!"Expected 4512, received: %s"(result.drawn));
	assert(result.score == 4512, format!"Expected 4512, received: %s"(result.score));
}

Result playUntilLastGame(in int[] numbers, Board[] boards)
{
	ulong countWon = boards.length;
	foreach (drawn; numbers)
	{
		foreach (ref board; boards)
		{
			if (board.won)
				continue;
			board.playDrawn(drawn);
			if (board.checkForWin())
			{
				--countWon;
				if (countWon == 0)
					return Result(board.score(drawn), drawn);
			}
		}
	}

	return Result(0, 0);
}

unittest
{
	Board[] boards = [
		Board([
			[22, 13, 17, 11, 0],
			[8, 2, 23, 4, 24],
			[21, 9, 14, 16, 7],
			[6, 10, 3, 18, 5],
			[1, 12, 20, 15, 19]
		]),
		Board([
			[3, 15, 0, 2, 22],
			[9, 18, 13, 17, 5],
			[19, 8, 7, 25, 23],
			[20, 11, 10, 24, 4],
			[14, 21, 16, 12, 6],
		]),
		Board([
			[14, 21, 17, 24, 4],
			[10, 16, 15, 9, 19],
			[18, 8, 23, 26, 20],
			[22, 11, 13, 6, 5],
			[2, 0, 12, 3, 7],
		])
	];
	const result = playUntilLastGame([
		7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22,
		18, 20, 8, 19, 3, 26, 1
	], boards);
	import std.string : format;

	assert(result.drawn == 13, format!"Expected 13, received: %s"(result.drawn));
	assert(result.score == 1924, format!"Expected 1924, received: %s"(result.score));
}

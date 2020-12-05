import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.regex;
import std.stdio;
import std.typecons;

void main()
{
	readText("day04.input").readChunks.map!(chunk => chunk.parseChunk.isValid ? 1 : 0).sum.writeln;
}

bool isValid(in string[string] fields) @safe
{
	bool validates = true;
	foreach (key, value; fields)
	{
		final switch (key)
		{
		case "byr":
			const year = value.to!int;
			validates = validates && year >= 1920 && year <= 2002;
			break;
		case "iyr":
			const year = value.to!int;
			validates = validates && year >= 2010 && year <= 2020;
			break;
		case "eyr":
			const year = value.to!int;
			validates = validates && year >= 2020 && year <= 2030;
			break;
		case "hgt":
			const match = value.matchFirst(regex(`(\d+)(cm|in)`));
			if (!match.empty)
			{
				if (match[2] == "cm")
				{
					const height = match[1].to!int;
					validates = validates && height >= 150 && height <= 193;
					break;
				}
				else if (match[2] == "in")
				{
					const height = match[1].to!int;
					validates = validates && height >= 59 && height <= 76;
					break;
				}
			}
			validates = false;
			break;
		case "hcl":
			validates = validates && !value.matchFirst(regex(`#[0-9a-f]{6}`)).empty;
			break;
		case "ecl":
			validates = validates && (value in ["amb": 0, "blu": 0, "brn": 0, "gry": 0, "grn": 0, "hzl": 0, "oth": 0]) !is null;
			break;
		case "pid":
			validates = validates && !value.matchFirst(regex(`^\d{9}$`)).empty;
			break;
		case "cid":
			// noop
			break;
		}
	}

	// dfmt off
	return 
	validates
	&& ("byr" in fields)
	&& ("iyr" in fields)
	&& ("eyr" in fields)
	&& ("hgt" in fields)
	&& ("hcl" in fields)
	&& ("ecl" in fields)
	&& ("pid" in fields);
	// dfmt on
}

unittest
{
	assert("pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f".parseChunk.isValid);
	assert("eyr:2029 ecl:blu cid:129 byr:1989 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm".parseChunk.isValid);
	assert("hcl:#888785 hgt:164cm byr:2001 iyr:2015 cid:88 pid:545766238 ecl:hzl eyr:2022".parseChunk.isValid);
	assert("iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719".parseChunk.isValid);
	assert(!"eyr:1972 cid:100 hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926".parseChunk.isValid);
	assert(!"iyr:2019 hcl:#602927 eyr:1967 hgt:170cm ecl:grn pid:012533040 byr:1946".parseChunk.isValid);
	assert(!"hcl:dab227 iyr:2012 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277".parseChunk.isValid);
	assert(!"hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007".parseChunk.isValid);

	assert(!"pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:2003 hcl:#623a2f".parseChunk.isValid);
	assert(!"pid:087499704 hgt:190in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f".parseChunk.isValid);
	assert(!"pid:087499704 hgt:190 ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f".parseChunk.isValid);
	assert(!"pid:087499704 hgt:190 ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#123abz".parseChunk.isValid);
	assert(!"pid:087499704 hgt:190 ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:123abc".parseChunk.isValid);

	assert(!"pid:087499704 hgt:74in ecl:wat iyr:2012 eyr:2030 byr:1980 hcl:#623a2f".parseChunk.isValid);

	assert(!"pid:0123456789 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f".parseChunk.isValid);
}

string[string] parseChunk(in string chunk) pure @safe
{
	return chunk.split
		.map!(field => field.split(":"))
		.map!(a => tuple(a[0], a[1]))
		.assocArray;
}

unittest
{
	assert("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm".parseChunk.length == 8);
	assert("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929".parseChunk.length == 7);
	assert("hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm".parseChunk.length == 7);
	assert("hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in".parseChunk.length == 6);
}

string[] readChunks(in string contents) pure @safe
{
	return contents.split("\n\n");
}

unittest
{
	const contents = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in";

	assert(contents.readChunks.length == 4);
}

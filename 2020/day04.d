import std.algorithm;
import std.array;
import std.file;
import std.stdio;
import std.typecons;

void main()
{
	readText("day04.input").readChunks.map!(chunk => chunk.parseChunk.isValid ? 1 : 0).sum.writeln;
}

bool isValid(in string[string] fields) pure @safe
{
	// dfmt off
	return 
	   ("byr" in fields)
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
	assert("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm".parseChunk.isValid);
	assert(!"iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929".parseChunk.isValid);
	assert("hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm".parseChunk.isValid);
	assert(!"hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in".parseChunk.isValid);
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

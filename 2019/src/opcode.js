export const instructionSet = (noun, verb, program) => {
  const values = program.split(",");
  values[1] = noun;
  values[2] = verb;
  return values;
};

/*
Inifinite Loop
[
  1, 4, 2, 1,
  2, 2, 2, 2,
  2, 2, 2, 2,
  2, 99
]
*/

export const operate = opcodes => {
  let index = 0;

  while (opcodes[index] !== "99") {
    const opcode = parseInt(opcodes[index++]);
    const read1 = parseInt(opcodes[index++]);
    const read2 = parseInt(opcodes[index++]);
    const write = parseInt(opcodes[index++]);

    const value1 = parseInt(opcodes[read1]);
    const value2 = parseInt(opcodes[read2]);

    switch (opcode) {
      case 1:
        opcodes[write] = (value1 + value2).toString();
        break;
      case 2:
        opcodes[write] = (value1 * value2).toString();
        break;
      default:
        console.error({ opcode, index, read1, read2, write, value1, value2 });
        break;
    }
  }

  return opcodes;
};

export const runProgram = program => operate(program.split(",")).join(",");

export const solveForNounAndVerb = program => {
  // Due to constraint solver (z3) eq is 19690720 = c1 + c2 * v + n
  const goal = 19690720;

  const r1 = parseInt(operate(instructionSet(12, 2, program))[0]);
  const r2 = parseInt(operate(instructionSet(13, 2, program))[0]);

  const c1 = 13 * r1 - 12 * r2 - 2;
  const c2 = r2 - r1;

  const val = goal - c1;
  const noun = val % c2;
  const verb = Math.floor(val / c2);

  console.log({ r1, r2, c1, c2 });

  return { noun, verb, res: 100 * verb + noun };
};

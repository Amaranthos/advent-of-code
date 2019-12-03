export const operate = program => {
  const opcodes = program.split(",");
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

  return opcodes.join(",");
};

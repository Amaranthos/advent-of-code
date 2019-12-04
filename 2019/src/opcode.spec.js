import {
  operate,
  instructionSet,
  runProgram,
  solveForNounAndVerb
} from "./opcode";
import { input as program } from "./day02";

describe("opcode", () => {
  it("should run the program", () => {
    expect(runProgram("1,0,0,0,99")).toBe("2,0,0,0,99");
    expect(runProgram("2,3,0,3,99")).toBe("2,3,0,6,99");
    expect(runProgram("1,1,1,4,99,5,6,0,99")).toBe("30,1,1,4,2,5,6,0,99");
  });

  describe("should solve day 2", () => {
    it("part 1", () => {
      expect(operate(instructionSet(12, 2, program))[0]).toBe("3706713");
    });

    it("part 2", () => {
      expect(solveForNounAndVerb(program)).toEqual({
        noun: 9,
        verb: 86,
        res: 8609
      });
    });
  });
});

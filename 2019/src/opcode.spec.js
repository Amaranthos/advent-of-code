import { operate } from "./opcode";

describe("opcode", () => {
  it("should run the program", () => {
    expect(operate("1,0,0,0,99")).toBe("2,0,0,0,99");
    expect(operate("2,3,0,3,99")).toBe("2,3,0,6,99");
    expect(operate("1,1,1,4,99,5,6,0,99")).toBe("30,1,1,4,2,5,6,0,99");
  });
});

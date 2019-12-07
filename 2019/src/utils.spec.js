import { switchcase } from "./utils";

describe("switchcase", () => {
  it("should switch", () => {
    const value = 42;
    expect(switchcase({ CASE: { value } })(value)("CASE")).toEqual({
      value: 42
    });
  });
});

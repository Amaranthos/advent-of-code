import { fuelRequired, sumFuelRequired } from "./index.js";

describe("fuel requirements", () => {
  it("the fuel required is based on the mass", () => {
    expect(fuelRequired(12)).toBe(2);
    expect(fuelRequired(14)).toBe(2);
    expect(fuelRequired(1969)).toBe(654);
    expect(fuelRequired(100756)).toBe(33583);
  });

  it("can calculate the fuel requirement for a list of modules", () => {
    expect(sumFuelRequired([12, 14])).toBe(4);
  });
});

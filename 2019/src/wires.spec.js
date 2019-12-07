import { getPath, directionReducer, linesOverlap } from "./wires";

describe("wires", () => {
  it("should describe a path", () => {
    expect(getPath("U7,R6,D4,L4")).toEqual([
      { x: 0, y: 0 },
      { x: 0, y: 7 },
      { x: 6, y: 7 },
      { x: 6, y: 3 },
      { x: 2, y: 3 }
    ]);
  });
});

describe("direction reducer", () => {
  it("U should move y by +1", () => {
    expect(
      directionReducer([], { dir: "U", dist: 1, offset: { x: 0, y: 0 } })
    ).toEqual([{ x: 0, y: 1 }]);
  });
  it("D should move y by -1", () => {
    expect(
      directionReducer([], { dir: "D", dist: 1, offset: { x: 0, y: 0 } })
    ).toEqual([{ x: 0, y: -1 }]);
  });
  it("L should move x by -1", () => {
    expect(
      directionReducer([], { dir: "L", dist: 1, offset: { x: 0, y: 0 } })
    ).toEqual([{ x: -1, y: 0 }]);
  });
  it("R should move x by +1", () => {
    expect(
      directionReducer([], { dir: "R", dist: 1, offset: { x: 0, y: 0 } })
    ).toEqual([{ x: 1, y: 0 }]);
  });
});

describe("overlap", () => {
  it("should overlap", () => {
    const line1 = { start: { x: 0, y: 1 }, end: { x: 3, y: 1 } };
    const line2 = { start: { x: 2, y: 0 }, end: { x: 2, y: 2 } };

    // expect(linesOverlap(line1, line2)).toBeTruthy();
  });
});

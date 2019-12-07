import { switchcase } from "./utils";

export const getPath = wire =>
  wire.split(",").reduce(
    (path, next) =>
      directionReducer(path, {
        dir: next.slice(0, 1),
        dist: parseInt(next.slice(1, next.length)),
        offset: path[path.length - 1]
      }),
    [{ x: 0, y: 0 }]
  );

export const directionReducer = (state = [], { dir, dist, offset }) =>
  switchcase({
    U: [...state, { x: offset.x, y: offset.y + dist }],
    D: [...state, { x: offset.x, y: offset.y - dist }],
    L: [...state, { x: offset.x - dist, y: offset.y }],
    R: [...state, { x: offset.x + dist, y: offset.y }]
  })(state)(dir);

export const linesOverlap = (line1, line2) => {
  return false;
};

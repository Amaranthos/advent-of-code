import {
  hasSameAdjacent,
  hasSameAdjacentReducer,
  isDescendingReducer,
  isDescending,
  meetsCriteria
} from "./password";

describe.only("password", () => {
  it.each([
    // [122345, true],
    // [111111, true],
    // [223450, true],
    // [123789, false],
    // [112233, true],
    // [123444, false],
    [111122, true]
  ])("expect hasSomeAdjacent of %i to be %p", (password, meets) => {
    expect(hasSameAdjacent(password)).toEqual(meets);
  });

  // it.each([
  // [122345, false],
  // [135679, false],
  // [111111, false],
  // [223450, true],
  // [123789, false],
  // [240922, true],
  // [112233, false],
  // [123444, false],
  // [111122, false]
  // ])("expect isDescending of %i to be %p", (password, meets) => {
  //   expect(isDescending(password)).toEqual(meets);
  // });

  // it.each([
  // [111111, true],
  // [223450, false],
  // [123789, false],
  // [112233, true],
  // [123444, false],
  // [111122, true]
  // ])("expect meetsCriteria of %i to be %p", (password, meets) => {
  //   expect(meetsCriteria(password)).toEqual(meets);
  // });
});

// describe("hasAdjacentReducer", () => {
//   it.each`
//     prev   | next   | index | array         | result
//     ${""}  | ${"1"} | ${0}  | ${["1", "1"]} | ${"1"}
//     ${"1"} | ${"1"} | ${1}  | ${["1", "1"]} | ${true}
//   `(
//     "$array[$index] should return $result",
//     ({ prev, next, index, array, result }) => {
//       expect(hasSameAdjacentReducer(prev, next, index, array)).toEqual(result);
//     }
//   );
//   it.each`
//     prev   | next   | index | array                   | result
//     ${""}  | ${"2"} | ${0}  | ${["2", "3", "4", "4"]} | ${"2"}
//     ${"2"} | ${"3"} | ${1}  | ${["2", "3", "4", "4"]} | ${"3"}
//     ${"3"} | ${"4"} | ${2}  | ${["2", "3", "4", "4"]} | ${"4"}
//     ${"4"} | ${"4"} | ${3}  | ${["2", "3", "4", "4"]} | ${true}
//   `(
//     "$array[$index] should return $result",
//     ({ prev, next, index, array, result }) => {
//       expect(hasSameAdjacentReducer(prev, next, index, array)).toEqual(result);
//     }
//   );
//   it.each`
//     prev    | next   | index | array                   | result
//     ${""}   | ${"2"} | ${0}  | ${["2", "2", "3", "4"]} | ${"2"}
//     ${"2"}  | ${"2"} | ${1}  | ${["2", "2", "3", "4"]} | ${true}
//     ${true} | ${"3"} | ${2}  | ${["2", "2", "3", "4"]} | ${true}
//     ${true} | ${"4"} | ${3}  | ${["2", "2", "3", "4"]} | ${true}
//   `(
//     "$array[$index] should return $result",
//     ({ prev, next, index, array, result }) => {
//       expect(hasSameAdjacentReducer(prev, next, index, array)).toEqual(result);
//     }
//   );
//   it.each`
//     prev    | next   | index | array                   | result
//     ${""}   | ${"2"} | ${0}  | ${["2", "2", "2", "2"]} | ${"2"}
//     ${"2"}  | ${"2"} | ${1}  | ${["2", "2", "2", "2"]} | ${true}
//     ${true} | ${"2"} | ${2}  | ${["2", "2", "2", "2"]} | ${"2"}
//     ${"2"}  | ${"2"} | ${3}  | ${["2", "2", "2", "2"]} | ${true}
//   `(
//     "$array[$index] should return $result",
//     ({ prev, next, index, array, result }) => {
//       expect(hasSameAdjacentReducer(prev, next, index, array)).toEqual(result);
//     }
//   );
// });

// describe("isDescendingReducer", () => {
//   it.each`
//     prev   | next   | index | array         | result
//     ${""}  | ${"1"} | ${0}  | ${["1", "1"]} | ${"1"}
//     ${"1"} | ${"1"} | ${1}  | ${["1", "1"]} | ${"1"}
//   `(
//     "$array[$index] should return $result",
//     ({ prev, next, index, array, result }) => {
//       expect(isDescendingReducer(prev, next, index, array)).toEqual(result);
//     }
//   );
//   it.each`
//     prev   | next   | index | array         | result
//     ${""}  | ${"1"} | ${0}  | ${["1", "0"]} | ${"1"}
//     ${"1"} | ${"0"} | ${1}  | ${["1", "0"]} | ${true}
//   `(
//     "$array[$index] should return $result",
//     ({ prev, next, index, array, result }) => {
//       expect(isDescendingReducer(prev, next, index, array)).toEqual(result);
//     }
//   );
// });

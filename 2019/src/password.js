export const calc = () => {
  const start = 240920;
  const end = 789857;
  let count = 0;
  let index = start;
  while (index !== end) {
    // console.log(index);
    if (meetsCriteria(index)) {
      count++;
      // console.log(index);
    }
    index++;
  }
  return count;
};

export const meetsCriteria = password =>
  hasSameAdjacent(password) && !isDescending(password);

export const hasSameAdjacent = password =>
  password
    .toString()
    .split("")
    .reduce(hasSameAdjacentReducer) === true;

export const isDescending = password =>
  password
    .toString()
    .split("")
    .reduce(isDescendingReducer) === true;

export const hasSameAdjacentReducer = (prev, next, i, arr) =>
  prev === true || prev === next ? true : next;

export const isDescendingReducer = (prev, next, i, arr) =>
  prev !== undefined && (prev === true || parseInt(next) < parseInt(prev))
    ? true
    : next;

console.log(calc());

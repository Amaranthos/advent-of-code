export const fuelRequired = mass => Math.floor(mass / 3) - 2;
export const sumFuelRequired = modules =>
  modules.reduce((sum, next) => fuelRequired(next) + sum, 0);

import { input } from "./day01.js";
console.log(sumFuelRequired(input));

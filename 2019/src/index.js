import { input as modules } from "./day01.js";
import { fuelRequiredForModules } from "./fuel.js";
console.log(fuelRequiredForModules(modules));

import { input as program } from "./day02.js";
import { operate } from "./opcode.js";
const values = program.split(",");
values[1] = 12;
values[2] = 2;
console.log(operate(values.join(",")));

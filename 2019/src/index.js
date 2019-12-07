import { input as modules } from "./day01.js";
import { fuelRequiredForModules } from "./fuel.js";
console.log(fuelRequiredForModules(modules));

import { input as program } from "./day02.js";
import { operate, instructionSet, solveForNounAndVerb } from "./opcode.js";
console.log(operate(instructionSet(12, 2, program)));
console.log(solveForNounAndVerb(program));

// Day 03

import { calc } from "./password.js";
console.log(calc());

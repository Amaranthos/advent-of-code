export const fuelRequired = mass => Math.floor(mass / 3) - 2;

export const fuelRequiredForModule = module => {
  let sum = fuelRequired(module);
  let remaining = sum;

  while (remaining > 0) {
    remaining = fuelRequired(remaining);
    if (remaining > 0) {
      sum += remaining;
    }
  }

  return sum;
};

export const fuelRequiredForModules = modules =>
  modules.reduce((sum, next) => fuelRequiredForModule(next) + sum, 0);

export const switchcase = cases => defaultCase => key =>
  (f => (f instanceof Function ? f() : f))(
    (cases => defaultCase => key =>
      cases.hasOwnProperty(key) ? cases[key] : defaultCase)(cases)(defaultCase)(
      key
    )
  );

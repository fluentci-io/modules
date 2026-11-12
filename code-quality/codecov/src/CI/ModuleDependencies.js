import { setup as setup0 } from "fluentci:dependency/setup-codecov";

const installers = { "setup-codecov": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

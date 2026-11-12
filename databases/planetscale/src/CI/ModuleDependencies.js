import { setup as setup0 } from "fluentci:dependency/setup-planetscale";

const installers = { "setup-planetscale": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

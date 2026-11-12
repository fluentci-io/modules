import { setup as setup0 } from "fluentci:dependency/setup-drizzlekit";

const installers = { "setup-drizzlekit": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

import { setup as setup0 } from "fluentci:dependency/setup-aws";

const installers = { "setup-aws": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

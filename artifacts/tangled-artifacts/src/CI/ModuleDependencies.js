import { setup as setup0 } from "fluentci:dependency/setup-tangled-artifacts";

const installers = { "setup-tangled-artifacts": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

import { setup as setup0 } from "fluentci:dependency/setup-cypress";
import { setup as setup1 } from "fluentci:dependency/setup-bun";

const installers = { "setup-cypress": setup0, "setup-bun": setup1 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

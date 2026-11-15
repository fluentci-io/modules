import { setup as setup0 } from "fluentci:dependency/setup-docker";
import { setup as setup1 } from "fluentci:dependency/setup-curl";

const installers = { "setup-docker": setup0, "setup-curl": setup1 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

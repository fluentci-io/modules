import { setup as setup0 } from "fluentci:dependency/setup-docker";
import { setup as setup1 } from "fluentci:dependency/setup-buildx";

const installers = { "setup-docker": setup0, "setup-buildx": setup1 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

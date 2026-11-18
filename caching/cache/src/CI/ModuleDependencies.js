import { setup as setup0 } from "fluentci:dependency/setup-node";
import { setup as setup1 } from "fluentci:dependency/setup-nix";

const installers = { "setup-node": setup0, "setup-nix": setup1 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

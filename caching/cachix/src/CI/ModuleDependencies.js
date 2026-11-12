import { setup as setup0 } from "fluentci:dependency/setup-nix";
import { setup as setup1 } from "fluentci:dependency/setup-cachix";

const installers = { "setup-nix": setup0, "setup-cachix": setup1 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

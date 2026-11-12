import { setup as setup0 } from "fluentci:dependency/setup-nix-package";

const installers = { "setup-nix-package": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

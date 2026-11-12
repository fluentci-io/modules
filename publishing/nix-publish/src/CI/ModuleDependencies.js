import { setup as setup0 } from "fluentci:dependency/setup-nix";
import { setup as setup1 } from "fluentci:dependency/setup-bun";
import { setup as setup2 } from "fluentci:dependency/setup-flakehub-push";

const installers = { "setup-nix": setup0, "setup-bun": setup1, "setup-flakehub-push": setup2 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

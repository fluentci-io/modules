import { setup as setup0 } from "fluentci:dependency/setup-glab";
import { setup as setup1 } from "fluentci:dependency/setup-git";

const installers = { "setup-glab": setup0, "setup-git": setup1 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

import { setup as setup0 } from "fluentci:dependency/setup-vercel";

const installers = { "setup-vercel": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

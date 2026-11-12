import { setup as setup0 } from "fluentci:dependency/setup-netlify";

const installers = { "setup-netlify": setup0 };
export const installDependency = alias => () => {
  const install = installers[alias];
  if (!install) throw Error("Unknown setup dependency: " + alias);
  install({});
};

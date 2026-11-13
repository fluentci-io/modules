import { setup } from "fluentci:dependency/setup-gh";
export const install = args => () => setup(args);
import { setup as setupGit } from "fluentci:dependency/setup-git";
export const installGit = () => { setupGit({}); };

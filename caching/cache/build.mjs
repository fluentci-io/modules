import { spawnSync } from "node:child_process";
import { buildModule } from "../../lib/component/build.mjs";
const installed = spawnSync("fluentci", ["install", "--frozen-lockfile"], {
  stdio: "inherit",
});
if (installed.error) throw installed.error;
if (installed.status !== 0) throw Error("Typed dependency preparation failed");
await buildModule(process.cwd(), { prepareDependencies: false });

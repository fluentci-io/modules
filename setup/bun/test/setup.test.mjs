import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("bun", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("bun", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("bun", new URL("../dist/plugin.cjs", import.meta.url));

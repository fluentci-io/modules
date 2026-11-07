import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("node", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("node", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("node", new URL("../dist/plugin.cjs", import.meta.url));

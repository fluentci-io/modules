import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("rust", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("rust", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("rust", new URL("../dist/plugin.cjs", import.meta.url));

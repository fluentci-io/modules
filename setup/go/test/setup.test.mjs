import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("go", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("go", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("go", new URL("../dist/plugin.cjs", import.meta.url));

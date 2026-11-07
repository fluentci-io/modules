import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("java", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("java", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("java", new URL("../dist/plugin.cjs", import.meta.url));

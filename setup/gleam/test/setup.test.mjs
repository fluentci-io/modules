import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("gleam", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("gleam", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("gleam", new URL("../dist/plugin.cjs", import.meta.url));

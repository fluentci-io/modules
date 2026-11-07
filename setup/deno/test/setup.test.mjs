import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("deno", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("deno", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("deno", new URL("../dist/plugin.cjs", import.meta.url));

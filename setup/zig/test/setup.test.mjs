import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("zig", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("zig", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("zig", new URL("../dist/plugin.cjs", import.meta.url));

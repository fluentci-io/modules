import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("elixir", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("elixir", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("elixir", new URL("../dist/plugin.cjs", import.meta.url));

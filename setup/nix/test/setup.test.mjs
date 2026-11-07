import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("nix", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("nix", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("nix", new URL("../dist/plugin.cjs", import.meta.url));

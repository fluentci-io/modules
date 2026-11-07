import { runSuite } from "../../../test/setup/suite.mjs";
runSuite("determinate-nix", new URL("../dist/plugin.cjs", import.meta.url));
import { runNative } from "../../../test/setup/native.mjs";
runNative("determinate-nix", new URL("../dist/plugin.cjs", import.meta.url));
import { runLive } from "../../../test/setup/live.mjs";
runLive("determinate-nix", new URL("../dist/plugin.cjs", import.meta.url));

import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("nix-package", new URL("../", import.meta.url));

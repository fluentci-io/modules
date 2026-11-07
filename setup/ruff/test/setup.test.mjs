import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("ruff", new URL("../", import.meta.url));

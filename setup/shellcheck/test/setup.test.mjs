import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("shellcheck", new URL("../", import.meta.url));

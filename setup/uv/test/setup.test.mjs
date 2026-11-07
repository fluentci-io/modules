import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("uv", new URL("../", import.meta.url));

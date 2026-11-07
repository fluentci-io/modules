import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("rustfmt", new URL("../", import.meta.url));

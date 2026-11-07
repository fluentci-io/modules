import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("openbao", new URL("../", import.meta.url));

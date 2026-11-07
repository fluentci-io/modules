import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("kubectl", new URL("../", import.meta.url));

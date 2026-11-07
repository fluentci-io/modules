import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("rpmbuild", new URL("../", import.meta.url));

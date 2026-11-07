import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("cypress", new URL("../", import.meta.url));

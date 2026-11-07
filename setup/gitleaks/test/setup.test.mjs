import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("gitleaks", new URL("../", import.meta.url));

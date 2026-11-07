import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("trivy", new URL("../", import.meta.url));

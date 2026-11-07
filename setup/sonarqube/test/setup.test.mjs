import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("sonarqube", new URL("../", import.meta.url));

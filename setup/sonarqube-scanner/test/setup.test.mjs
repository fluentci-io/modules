import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("sonarqube-scanner", new URL("../", import.meta.url));

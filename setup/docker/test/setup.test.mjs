import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("docker", new URL("../", import.meta.url));

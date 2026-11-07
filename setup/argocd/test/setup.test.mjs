import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("argocd", new URL("../", import.meta.url));

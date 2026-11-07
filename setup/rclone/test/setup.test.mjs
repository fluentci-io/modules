import { suite } from "../../../test/setup-tools/suite.mjs";
await suite("rclone", new URL("../", import.meta.url));

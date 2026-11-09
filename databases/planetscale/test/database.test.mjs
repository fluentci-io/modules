import {databaseSuite} from "../../../test/cli/database.mjs";
await databaseSuite("planetscale",new URL("../",import.meta.url));

import {databaseSuite} from "../../../test/cli/database.mjs";
await databaseSuite("xata",new URL("../",import.meta.url));

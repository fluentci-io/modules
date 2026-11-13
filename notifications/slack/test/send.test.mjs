import {notificationSuite} from "../../../test/notifications/suite.mjs";
await notificationSuite("slack",new URL("../",import.meta.url));

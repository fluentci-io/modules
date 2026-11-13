import {notificationSuite} from "../../../test/notifications/suite.mjs";
await notificationSuite("telegram",new URL("../",import.meta.url));

import {notificationSuite} from "../../../test/notifications/suite.mjs";
await notificationSuite("discord",new URL("../",import.meta.url));

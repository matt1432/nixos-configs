import Setup from './setup.js';
import AppLauncher from './applauncher/main.js';
import Bar from './bar/main.js';
import BgFade from './misc/background-fade.js';
import Calendar from './date.js';
import Corners from './corners/main.js';
import { NotifPopups, NotifCenter } from './notifications/main.js';
import OSD from './osd/main.js';
import OSK from './on-screen-keyboard/main.js';
import Overview from './overview/main.js';
import Powermenu from './powermenu.js';
import QSettings from './quick-settings/main.js';

Setup();

const closeWinDelay = 800;


export default {
    notificationPopupTimeout: 5000,
    cacheNotificationActions: true,
    closeWindowDelay: {
        'applauncher': closeWinDelay,
        'calendar': closeWinDelay,
        'notification-center': closeWinDelay,
        'osd': 300,
        'osk': closeWinDelay,
        'overview': closeWinDelay,
        'powermenu': closeWinDelay,
        'quick-settings': closeWinDelay,
    },
    windows: [
        // Put the corners first so they
        // don't block the cursor on the bar
        ...Corners(),

        AppLauncher(),
        Calendar(),
        NotifCenter(),
        OSD(),
        OSK(),
        Overview(),
        Powermenu(),
        QSettings(),

        Bar(),
        BgFade(),
        NotifPopups(),
    ],
};

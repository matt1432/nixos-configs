import Setup from './setup.ts';
import AppLauncher from './applauncher/main.ts';
import Bar from './bar/main.ts';
import BgFade from './misc/background-fade.ts';
import Calendar from './date.ts';
import Corners from './corners/main.ts';
import { NotifPopups, NotifCenter } from './notifications/main.ts';
import OSD from './osd/main.ts';
import OSK from './on-screen-keyboard/main.ts';
import Overview from './overview/main.ts';
import Powermenu from './powermenu.ts';
import QSettings from './quick-settings/main.ts';

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

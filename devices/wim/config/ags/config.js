import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js';

import Setup from './js/setup.js';
import AppLauncher from './js/applauncher/main.js';
import Bar from './js/bar/main.js';
import BgFade from './js/misc/background-fade.js';
import Calendar from './js/date.js';
import Corners from './js/corners/main.js';
import { NotifPopups, NotifCenter } from './js/notifications/main.js';
import OSD from './js/osd/main.js';
import OSK from './js/on-screen-keyboard/main.js';
import Overview from './js/overview/main.js';
import Powermenu from './js/powermenu.js';
import QSettings from './js/quick-settings/main.js';

const scss = `${App.configDir }/scss/main.scss`;
const css = `${App.configDir }/style.css`;
const closeWinDelay = 500;

exec(`sassc ${scss} ${css}`);
Setup();


export default {
    style: css,
    notificationPopupTimeout: 5000,
    cacheNotificationActions: true,
    closeWindowDelay: {
        'applauncher': closeWinDelay,
        'calendar': closeWinDelay,
        'notification-center': closeWinDelay,
        'osd': closeWinDelay,
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

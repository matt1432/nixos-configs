import App      from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js';

import Setup       from './js/setup.js';
import AppLauncher from './js/applauncher/main.js';
import Bar         from './js/bar/main.js';
import BgFade      from './js/misc/background-fade.js';
import Calendar    from './js/date.js';
import Corners     from './js/corners/main.js';
import NotifCenter from './js/notifications/center.js';
import NotifPopups from './js/notifications/popup.js';
import OSD         from './js/osd/main.js';
import Overview    from './js/overview/main.js';
import Powermenu   from './js/powermenu.js';
import QSettings   from './js/quick-settings/main.js';

const scss = App.configDir + '/scss/main.scss';
const css  = App.configDir + '/style.css';
exec(`sassc ${scss} ${css}`);
Setup();


export default {
    style: css,
    notificationPopupTimeout: 5000,
    cacheNotificationActions: true,
    closeWindowDelay: {
        'applauncher': 500,
        'calendar': 500,
        'notification-center': 500,
        'osd': 500,
        'overview': 500,
        'powermenu': 500,
        'quick-settings': 500,
    },
    windows: [
        AppLauncher(),
        Calendar(),
        NotifCenter(),
        OSD(),
        Overview(),
        Powermenu(),
        QSettings(),

        Bar(),
        BgFade(),
        ...Corners(),
        NotifPopups(),
    ],
};

import Pointers from '../wim/services/pointers.js';

import AppLauncher from '../wim/ts/applauncher/main.js';
import Bar from './bar/main.js';
import { NotifPopups, NotifCenter } from './notifications/main.js';
import Powermenu from '../wim/ts/powermenu.js';

const closeWinDelay = 800;


// TODO: add OSD, workspace indicator / overview and current window indicator
export default {
    notificationPopupTimeout: 5000,
    cacheNotificationActions: true,

    onConfigParsed: () => {
        globalThis.Pointers = Pointers;
    },

    closeWindowDelay: {
        'applauncher': closeWinDelay,
        'notification-center': closeWinDelay,
        'powermenu': closeWinDelay,
    },
    windows: [
        AppLauncher(),
        NotifCenter(),
        Powermenu(),

        Bar(),
        NotifPopups(),
    ],
};

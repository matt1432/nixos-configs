import Pointers from './services/pointers.ts';

import AppLauncher from './ts/applauncher/main.ts';
import Bar from './ts/bar/binto.ts';
import { NotifPopups, NotifCenter } from './ts/notifications/binto.ts';
import Powermenu from './ts/powermenu.ts';

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

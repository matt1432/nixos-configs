import Pointers from '../../../../wim/config/ags/services/pointers.ts';

import AppLauncher from '../../../../wim/config/ags/ts/applauncher/main.ts';
import Bar from './bar/main.ts';
import { NotifPopups, NotifCenter } from './notifications/main.ts';
import Powermenu from '../../../../wim/config/ags/ts/powermenu.ts';

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

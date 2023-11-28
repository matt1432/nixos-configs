import App      from 'resource:///com/github/Aylur/ags/app.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js';

import Pointers from 'file:///home/matt/.nix/devices/wim/config/ags/services/pointers.js';

import Bar from './js/bar/main.js';
import { NotifPopups, NotifCenter } from './js/notifications/main.js';

const scss = App.configDir + '/scss/main.scss';
const css  = App.configDir + '/style.css';
exec(`sassc ${scss} ${css}`);


export default {
    style: css,

    notificationPopupTimeout: 5000,
    cacheNotificationActions: true,

    onConfigParsed: () => {
        globalThis.Ponters = Pointers;
    },

    closeWindowDelay: {
        'notification-center': 500,
    },
    windows: [
        Bar(),
        NotifCenter(),
        NotifPopups(),
    ],
};
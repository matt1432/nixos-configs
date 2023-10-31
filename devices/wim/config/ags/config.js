// Has to be a traditional function for 'this' scope
Array.prototype.remove = function (el) { this.splice(this.indexOf(el), 1); };

import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import closeAll from './js/misc/closer.js';
globalThis.closeAll = closeAll;

import Powermenu     from './js/powermenu.js';
import * as Bar      from './js/bar/main.js';
import NotifCenter   from './js/notifications/center.js';
import NotifPopups   from './js/notifications/popup.js';
import Calendar      from './js/date.js';
import QuickSettings from './js/quick-settings/main.js';
import Overview      from './js/overview/main.js';
import AppLauncher   from './js/applauncher/main.js';
import * as Corners  from './js/screen-corners.js';


const scss = App.configDir + '/scss/main.scss';
const css  = App.configDir + '/style.css';

exec(`sassc ${scss} ${css}`);

execAsync(['bash', '-c', '$AGS_PATH/startup.sh']).catch(print);


export default {
    style: css,
    notificationPopupTimeout: 5000,
    cacheNotificationActions: true,
    closeWindowDelay: {
        'applauncher': 500,
        'calendar': 500,
        'notification-center': 500,
        'overview': 500,
        'powermenu': 500,
        'quick-settings': 500,
    },
    windows: [
        AppLauncher(),
        Calendar(),
        NotifCenter(),
        Overview(),
        Powermenu(),
        QuickSettings(),

        Bar.Bar(),
        Bar.BgGradient(),
        Corners.Bottomleft(),
        Corners.Bottomright(),
        NotifPopups(),
    ],
};
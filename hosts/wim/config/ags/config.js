import { App, Utils }             from './imports.js';

import { Powermenu }              from './js/powermenu.js';
import { Bar }                    from './js/bar/main.js';
import { NotificationCenter }     from './js/notifications/center.js';
import { NotificationsPopupList } from './js/notifications/popup.js'
import { Calendar }               from './js/date.js';
import { QuickSettings }          from './js/quick-settings/main.js';
import Overview                   from './js/overview/main.js';
import AppLauncher                from './js/applauncher/main.js';

import { Closer, closeAll }       from './js/misc/closer.js';
globalThis.closeAll = () => closeAll();


const scss = App.configDir + '/scss/main.scss';
const css  = App.configDir + '/style.css';

Utils.exec(`sassc ${scss} ${css}`);

Utils.execAsync(['bash', '-c', '$AGS_PATH/startup.sh']).catch(print);


export default {
  style: css,
  notificationPopupTimeout: 5000,
  cacheNotificationActions: true,
  closeWindowDelay: {
    'quick-settings': 500,
    'notification-center': 500,
    'calendar': 500,
    'powermenu': 500,
    'overview': 500,
    'applauncher': 500,
  },
  windows: [
    Powermenu,
    Bar,
    Closer,
    NotificationCenter,
    NotificationsPopupList,
    Calendar,
    QuickSettings,
    Overview,
    AppLauncher,
  ],
};

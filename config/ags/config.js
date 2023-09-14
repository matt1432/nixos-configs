import { exec } from 'resource:///com/github/Aylur/ags/utils.js';
import { Powermenu } from './js/powermenu.js';
import { Bar } from './js/bar/main.js';
import { NotificationCenter } from './js/notifications/center.js';
import { NotificationsPopupList } from './js/notifications/popup.js'
import { Calendar } from './js/date.js';
import { QuickSettings } from './js/quick-settings/main.js';

import { Closer, closeAll } from './js/misc/closer.js';
ags.App.closeAll = () => closeAll();

const scss = ags.App.configDir + '/scss/main.scss';
const css = ags.App.configDir + '/style.css';

exec(`sassc ${scss} ${css}`);

exec(`bash -c "$AGS_PATH/startup.sh"`);

export default {
  style: css,
  notificationPopupTimeout: 5000,
  windows: [
    Powermenu,
    Bar,
    Closer,
    NotificationCenter,
    NotificationsPopupList,
    Calendar,
    QuickSettings,
  ],
};

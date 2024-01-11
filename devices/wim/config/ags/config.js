import { watchAndCompileSass } from './js/utils.js';
import windows from './js/main.js';

watchAndCompileSass();

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
        ...windows,
    ],
};

import Pointers from './services/pointers.ts';

import AppLauncher from './ts/applauncher/main.ts';
import Bar from './ts/bar/binto.ts';
import { NotifPopups, NotifCenter } from './ts/notifications/binto.ts';
import Powermenu from './ts/powermenu.ts';


// TODO: add OSD, workspace indicator and current window indicator
export default {
    onConfigParsed: () => {
        globalThis.Pointers = Pointers;
    },

    windows: [
        AppLauncher(),
        NotifCenter(),
        Powermenu(),

        Bar(),
        NotifPopups(),
    ],
};

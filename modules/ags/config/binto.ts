import Pointers from './services/pointers.ts';

import AppLauncher from './ts/applauncher/main.ts';
import Bar from './ts/bar/binto.ts';
import { NotifPopups, NotifCenter } from './ts/notifications/binto.ts';
import OSD from './ts/osd/main.ts';
import Powermenu from './ts/powermenu.ts';


// TODO: add workspace indicator and current window indicator
App.config({
    icons: './icons',

    onConfigParsed: () => {
        globalThis.Pointers = Pointers;
    },

    windows: () => [
        AppLauncher(),
        NotifCenter(),
        Powermenu(),

        Bar(),
        NotifPopups(),
        OSD(),
    ],
});

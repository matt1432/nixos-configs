import Pointers from './services/pointers.ts';
import Brightness from './services/brightness.ts';

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

        Brightness.capsName = 'input30::capslock';
        globalThis.Brightness = Brightness;
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

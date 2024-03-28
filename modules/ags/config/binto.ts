import Brightness from './services/brightness.ts';
import GSR from './services/gpu-screen-recorder.ts';
import Pointers from './services/pointers.ts';

import AppLauncher from './ts/applauncher/main.ts';
import Bar from './ts/bar/binto.ts';
import { NotifPopups, NotifCenter } from './ts/notifications/binto.ts';
import OSD from './ts/osd/main.ts';
import Powermenu from './ts/powermenu.ts';


// TODO: add workspace indicator
App.config({
    icons: './icons',

    onConfigParsed: () => {
        Brightness.capsName = 'input30::capslock';
        globalThis.Brightness = Brightness;
        globalThis.Pointers = Pointers;
        globalThis.GSR = GSR;
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

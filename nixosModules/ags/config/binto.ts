import Brightness from './services/brightness.ts';
import GSR from './services/gpu-screen-recorder.ts';
import Pointers from './services/pointers.ts';

import AppLauncher from './ts/applauncher/main.ts';
import Bar from './ts/bar/binto.ts';
import Clipboard from './ts/clipboard/main.ts';
import Calendar from './ts/date/binto.ts';
import { NotifPopups, NotifCenter } from './ts/notifications/binto.ts';
import OSD from './ts/osd/main.ts';
import Powermenu from './ts/powermenu.ts';
import Screenshot from './ts/screenshot/main.ts';


// TODO: add workspace indicator
App.config({
    icons: './icons',

    onConfigParsed: () => {
        Brightness.capsName = 'input30::capslock';
        globalThis.Brightness = Brightness;
        globalThis.Pointers = Pointers;
        setTimeout(() => {
            globalThis.GSR = new GSR();
        }, 1000);
    },

    windows: () => [
        AppLauncher(),
        Calendar(),
        Clipboard(),
        NotifCenter(),
        Powermenu(),
        Screenshot(),

        Bar(),
        NotifPopups(),
        OSD(),
    ],
});

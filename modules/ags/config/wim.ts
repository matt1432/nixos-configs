import Setup from './ts/setup.ts';
import AppLauncher from './ts/applauncher/main.ts';
import Bar from './ts/bar/wim.ts';
import BgFade from './ts/misc/background-fade.ts';
import Calendar from './ts/date/wim.ts';
import Clipboard from './ts/clipboard/main.ts';
import Corners from './ts/corners/main.ts';
import { NotifPopups, NotifCenter } from './ts/notifications/wim.ts';
import OSD from './ts/osd/main.ts';
import OSK from './ts/on-screen-keyboard/main.ts';
import Powermenu from './ts/powermenu.ts';
import QSettings from './ts/quick-settings/main.ts';
import Screenshot from './ts/screenshot/main.ts';


App.config({
    icons: './icons',

    onConfigParsed: () => {
        Setup();
    },

    windows: () => [
        ...Corners(),

        AppLauncher(),
        Calendar(),
        Clipboard(),
        NotifCenter(),
        OSD(),
        OSK(),
        Powermenu(),
        QSettings(),
        Screenshot(),

        Bar(),
        BgFade(),
        NotifPopups(),
    ],
});

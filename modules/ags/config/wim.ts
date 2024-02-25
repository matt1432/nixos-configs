import Setup from './ts/setup.ts';
import AppLauncher from './ts/applauncher/main.ts';
import Bar from './ts/bar/wim.ts';
import BgFade from './ts/misc/background-fade.ts';
import Calendar from './ts/date.ts';
import Corners from './ts/corners/main.ts';
import { NotifPopups, NotifCenter } from './ts/notifications/wim.ts';
import OSD from './ts/osd/main.ts';
import OSK from './ts/on-screen-keyboard/main.ts';
import Powermenu from './ts/powermenu.ts';
import QSettings from './ts/quick-settings/main.ts';

Setup();


export default {
    icons: './icons',

    windows: [
        ...Corners(),

        AppLauncher(),
        Calendar(),
        NotifCenter(),
        OSD(),
        OSK(),
        Powermenu(),
        QSettings(),

        Bar(),
        BgFade(),
        NotifPopups(),
    ],
};

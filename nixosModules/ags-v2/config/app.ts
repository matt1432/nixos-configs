import { execAsync } from 'astal';
import { App } from 'astal/gtk3';

import GLib from 'gi://GLib';

import style from './style/main.scss';

import AppLauncher from './widgets/applauncher/main';
import Bar from './widgets/bar/wim';
import BgFade from './widgets/bg-fade/main';
import Calendar from './widgets/date/main';
import Clipboard from './widgets/clipboard/main';
import Corners from './widgets/corners/main';
import IconBrowser from './widgets/icon-browser/main';
import { NotifPopups, NotifCenter } from './widgets/notifs/main';
import OSD from './widgets/osd/main';
import PowerMenu from './widgets/powermenu/main';
import Screenshot from './widgets/screenshot/main';

import { closeAll as closeAllFunc } from './lib';
import BrightnessService from './services/brightness';
import MonitorClicks from './services/monitor-clicks';

import Lockscreen from './widgets/lockscreen/main';

declare global {
    function closeAll(): void;
    // eslint-disable-next-line
    var Brightness: typeof BrightnessService;
}
globalThis.closeAll = closeAllFunc;
globalThis.Brightness = BrightnessService;


const CONF = GLib.getenv('CONF');

switch (CONF) {
    case 'lock': {
        App.start({
            css: style,
            instanceName: CONF,

            main: () => {
                Lockscreen();
            },
        });

        break;
    }

    case 'wim': {
        App.start({
            css: style,

            requestHandler(js, res) {
                App.eval(js).then(res).catch(res);
            },

            main: () => {
                execAsync('hyprpaper').catch(print);

                AppLauncher();
                Bar();
                BgFade();
                Calendar();
                Clipboard();
                Corners();
                IconBrowser();
                NotifPopups();
                NotifCenter();
                OSD();
                PowerMenu();
                Screenshot();

                Brightness.initService({
                    kbd: 'tpacpi::kbd_backlight',
                    caps: 'input1::capslock',
                });
                new MonitorClicks();

                setTimeout(() => {
                    App.get_window('win-applauncher')?.set_visible(true);
                }, 3 * 1000);
            },
        });

        break;
    }
}

import { App } from 'astal/gtk3';

import GLib from 'gi://GLib?version=2.0';

import style from './style.scss';

import AppLauncher from './widgets/applauncher/main';
import Bar from './widgets/bar/wim';
import BgFade from './widgets/bg-fade/main';
import Calendar from './widgets/date/main';
import Corners from './widgets/corners/main';
import IconBrowser from './widgets/icon-browser/main';
import { NotifPopups, NotifCenter } from './widgets/notifs/main';
import PowerMenu from './widgets/powermenu/main';

import MonitorClicks from './services/monitor-clicks';

import Lockscreen from './widgets/lockscreen/main';


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

            main: () => {
                AppLauncher();
                Bar();
                BgFade();
                Calendar();
                Corners();
                IconBrowser();
                NotifPopups();
                NotifCenter();
                PowerMenu();

                new MonitorClicks();
            },
        });

        break;
    }
}

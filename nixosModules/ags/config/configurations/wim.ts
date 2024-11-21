import { execAsync } from 'astal';
import { App } from 'astal/gtk3';

import style from '../style/main.scss';

import AppLauncher from '../widgets/applauncher/main';
import Bar from '../widgets/bar/wim';
import BgLayer from '../widgets/bg-layer/main';
import Calendar from '../widgets/date/wim';
import Clipboard from '../widgets/clipboard/main';
import Corners from '../widgets/corners/main';
import IconBrowser from '../widgets/icon-browser/main';
import { NotifPopups, NotifCenter } from '../widgets/notifs/wim';
import OSD from '../widgets/osd/main';
import PowerMenu from '../widgets/powermenu/main';
import Screenshot from '../widgets/screenshot/main';

import { closeAll, perMonitor } from '../lib';
import Brightness from '../services/brightness';
import MonitorClicks from '../services/monitor-clicks';


export default () => {
    App.start({
        css: style,

        requestHandler(request, respond) {
            if (request.startsWith('open')) {
                App.get_window(request.replace('open ', ''))?.set_visible(true);
                respond('window opened');
            }
            else if (request.startsWith('closeAll')) {
                closeAll();
                respond('closed all windows');
            }
            else if (request.startsWith('fetchCapsState')) {
                Brightness.get_default().fetchCapsState();
                respond('fetched caps_lock state');
            }
            else if (request.startsWith('Brightness.screen')) {
                Brightness.get_default().screen += parseFloat(request.replace('Brightness.screen ', ''));
                respond('screen brightness changed');
            }
            else if (request.startsWith('popup')) {
                popup_osd(request.replace('popup ', ''));
                respond('osd popped up');
            }
            else if (request.startsWith('osk')) {
                console.log(`TODO: ${request.replace('osk ', '')}`);
                respond('implement this');
            }
        },

        main: () => {
            execAsync('hyprpaper').catch(() => { /**/ });

            perMonitor((monitor) => BgLayer(monitor, true));

            AppLauncher();
            Bar();
            Calendar();
            Clipboard();
            Corners();
            IconBrowser();
            NotifPopups();
            NotifCenter();
            OSD();
            PowerMenu();
            Screenshot();

            Brightness.get_default({
                kbd: 'tpacpi::kbd_backlight',
                caps: 'input1::capslock',
            });
            MonitorClicks.get_default();
        },
    });
};

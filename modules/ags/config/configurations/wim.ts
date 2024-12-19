import { execAsync } from 'astal';
import { App } from 'astal/gtk3';

import style from '../style/main.scss';

import AppLauncher from '../widgets/applauncher';
import AudioWindow from '../widgets/audio/wim';
import Bar from '../widgets/bar/wim';
import BgLayer from '../widgets/bg-layer';
import BluetoothWindow from '../widgets/bluetooth/wim';
import Calendar from '../widgets/date/wim';
import Clipboard from '../widgets/clipboard';
import Corners from '../widgets/corners';
import IconBrowser from '../widgets/icon-browser';
import NetworkWindow from '../widgets/network/wim';
import { NotifPopups, NotifCenter } from '../widgets/notifs/wim';
import OnScreenDisplay from '../widgets/on-screen-display';
import OnScreenKeyboard from '../widgets/on-screen-keyboard';
import PowerMenu from '../widgets/powermenu';
import Screenshot from '../widgets/screenshot';

import { closeAll, perMonitor } from '../lib';
import Brightness from '../services/brightness';
import MonitorClicks from '../services/monitor-clicks';
import Tablet from '../services/tablet';


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

            else if (request.startsWith('show-osk')) {
                const tablet = Tablet.get_default();

                if (tablet.currentMode === 'tablet') {
                    if (tablet.oskState) {
                        respond('osk state was unchanged');
                    }
                    else {
                        tablet.oskState = true;
                        tablet.oskAutoChanged = true;
                        respond('osk was shown');
                    }
                }
                else {
                    respond('osk state was unchanged');
                }
            }

            else if (request.startsWith('hide-osk')) {
                const tablet = Tablet.get_default();

                if (tablet.currentMode === 'tablet') {
                    if (tablet.oskState && tablet.oskAutoChanged) {
                        tablet.oskState = false;
                        tablet.oskAutoChanged = true;
                        respond('osd was hidden');
                    }
                    else {
                        respond('osk state was unchanged');
                    }
                }
                else {
                    respond('osk state was unchanged');
                }
            }
        },

        main: () => {
            execAsync('hyprpaper').catch(() => { /**/ });

            perMonitor((monitor) => BgLayer(monitor, true));

            AppLauncher();
            AudioWindow();
            Bar();
            BluetoothWindow();
            Calendar();
            Clipboard();
            Corners();
            IconBrowser();
            NetworkWindow();
            NotifPopups();
            NotifCenter();
            OnScreenDisplay();
            OnScreenKeyboard();
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

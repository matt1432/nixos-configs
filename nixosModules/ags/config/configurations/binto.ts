import { execAsync } from 'astal';
import { App } from 'astal/gtk3';

import style from '../style/main.scss';

import AppLauncher from '../widgets/applauncher/main';
import Bar from '../widgets/bar/binto';
import BgLayer from '../widgets/bg-layer/main';
import Calendar from '../widgets/date/binto';
import Clipboard from '../widgets/clipboard/main';
import { NotifPopups, NotifCenter } from '../widgets/notifs/binto';
import OSD from '../widgets/osd/main';
import PowerMenu from '../widgets/powermenu/main';
import Screenshot from '../widgets/screenshot/main';

import { closeAll, perMonitor } from '../lib';
import Brightness from '../services/brightness';
import GSR from '../services/gpu-screen-recorder';
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
            else if (request.startsWith('popup')) {
                popup_osd(request.replace('popup ', ''));
                respond('osd popped up');
            }
            else if (request.startsWith('save-replay')) {
                GSR.get_default().saveReplay();
                respond('saving replay');
            }
        },

        main: () => {
            execAsync('hyprpaper').catch(() => { /**/ });

            perMonitor((monitor) => BgLayer(monitor, false));

            AppLauncher();
            Bar();
            Calendar();
            Clipboard();
            NotifPopups();
            NotifCenter();
            OSD();
            PowerMenu();
            Screenshot();

            Brightness.get_default({ caps: 'input2::capslock' });
            GSR.get_default();
            MonitorClicks.get_default();
        },
    });
};

import { execAsync } from 'astal';
import { App } from 'astal/gtk3';

import style from '../style/main.scss';

import AppLauncher from '../widgets/applauncher';
import AudioWindow from '../widgets/audio/binto';
import Bar from '../widgets/bar/binto';
import BgLayer from '../widgets/bg-layer';
import Calendar from '../widgets/date/binto';
import Clipboard from '../widgets/clipboard';
import { NotifPopups, NotifCenter } from '../widgets/notifs/binto';
import OnScreenDisplay from '../widgets/on-screen-display';
import PowerMenu from '../widgets/powermenu';
import Screenshot from '../widgets/screenshot';

import { closeAll, getWindow, perMonitor } from '../lib';
import Brightness from '../services/brightness';
import GpuScreenRecorder from '../services/gpu-screen-recorder';
import MonitorClicks from '../services/monitor-clicks';


export default () => {
    App.start({
        css: style,

        requestHandler(request, respond) {
            if (request.startsWith('open')) {
                getWindow(request.replace('open ', ''))?.set_visible(true);
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
                GpuScreenRecorder.get_default().saveReplay();
                respond('saving replay');
            }
        },

        main: () => {
            execAsync('hyprpaper').catch(() => { /**/ });

            perMonitor((monitor) => BgLayer(monitor, false));

            AppLauncher();
            AudioWindow();
            Bar();
            Calendar();
            Clipboard();
            NotifPopups();
            NotifCenter();
            OnScreenDisplay();
            PowerMenu();
            Screenshot();

            Brightness.get_default({ caps: 'input2::capslock' });
            GpuScreenRecorder.get_default();
            MonitorClicks.get_default();
        },
    });
};

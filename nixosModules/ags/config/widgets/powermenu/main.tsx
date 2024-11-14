import { execAsync } from 'astal';
import { Astal } from 'astal/gtk3';

import { hyprMessage } from '../../lib';

import PopupWindow from '../misc/popup-window';


const PowermenuWidget = () => (
    <centerbox className="powermenu widget">
        <button
            className="shutdown button"
            cursor="pointer"
            onButtonReleaseEvent={() => execAsync(['systemctl', 'poweroff']).catch(print)}
        >
            <icon icon="system-shutdown-symbolic" />
        </button>

        <button
            className="reboot button"
            cursor="pointer"
            onButtonReleaseEvent={() => execAsync(['systemctl', 'reboot']).catch(print)}
        >
            <icon icon="system-restart-symbolic" />
        </button>

        <button
            className="logout button"
            cursor="pointer"
            onButtonReleaseEvent={() => hyprMessage('dispatch exit').catch(print)}
        >
            <icon icon="system-log-out-symbolic" />
        </button>
    </centerbox>
);

export default () => (
    <PopupWindow
        name="powermenu"
        transition="slide bottom"
        // To put it at the center of the screen
        exclusivity={Astal.Exclusivity.IGNORE}
    >
        <PowermenuWidget />
    </PopupWindow>
);

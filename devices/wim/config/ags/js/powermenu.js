import { CenterBox, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import PopupWindow from './misc/popup.js';
import Button      from './misc/cursorbox.js';


const PowermenuWidget = () => CenterBox({
    className: 'powermenu',
    vertical: false,

    startWidget: Button({
        isButton: true,
        className: 'shutdown',
        onPrimaryClickRelease: () => execAsync(['systemctl', 'poweroff']).catch(print),

        child: Label({
            label: '襤',
        }),
    }),

    centerWidget: Button({
        isButton: true,
        className: 'reboot',
        onPrimaryClickRelease: () => execAsync(['systemctl', 'reboot']).catch(print),

        child: Label({
            label: '勒',
        }),
    }),

    endWidget: Button({
        isButton: true,
        className: 'logout',
        onPrimaryClickRelease: () => execAsync(['hyprctl', 'dispatch', 'exit']).catch(print),

        child: Label({
            label: '',
        }),
    }),
});

export default () => PopupWindow({
    name: 'powermenu',
    transition: 'crossfade',
    child: PowermenuWidget(),
});

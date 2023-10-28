import { Widget } from '../imports.js';
const { CenterBox, Label } = Widget;

import PopupWindow from './misc/popup.js';
import Button      from './misc/cursorbox.js';


const PowermenuWidget = () => CenterBox({
    className: 'powermenu',
    vertical: false,

    startWidget: Button({
        type: 'Button',
        className: 'shutdown',
        onPrimaryClickRelease: 'systemctl poweroff',

        child: Label({
            label: '襤',
        }),
    }),

    centerWidget: Button({
        type: 'Button',
        className: 'reboot',
        onPrimaryClickRelease: 'systemctl reboot',

        child: Label({
            label: '勒',
        }),
    }),

    endWidget: Button({
        type: 'Button',
        className: 'logout',
        onPrimaryClickRelease: 'hyprctl dispatch exit',

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

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { CenterBox, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import PopupWindow from './misc/popup.js';
import CursorBox from './misc/cursorbox.js';


// FIXME: eventboxes are the wrong size
const PowermenuWidget = () => CenterBox({
    class_name: 'powermenu',
    // @ts-expect-error
    vertical: false,

    startWidget: CursorBox({
        class_name: 'shutdown',
        on_primary_click_release: () => execAsync(['systemctl', 'poweroff'])
            .catch(print),

        child: Label({
            label: '襤',
        }),
    }),

    centerWidget: CursorBox({
        class_name: 'reboot',
        on_primary_click_release: () => execAsync(['systemctl', 'reboot'])
            .catch(print),

        child: Label({
            label: '勒',
        }),
    }),

    endWidget: CursorBox({
        class_name: 'logout',
        on_primary_click_release: () => Hyprland.sendMessage('dispatch exit')
            .catch(print),

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

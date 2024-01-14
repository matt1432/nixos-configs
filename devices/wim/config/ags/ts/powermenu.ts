import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { CenterBox, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import PopupWindow from './misc/popup.ts';
import CursorBox from './misc/cursorbox.ts';


const PowermenuWidget = () => CenterBox({
    class_name: 'powermenu',
    // @ts-expect-error
    vertical: false,

    start_widget: CursorBox({
        class_name: 'shutdown button',
        on_primary_click_release: () => execAsync(['systemctl', 'poweroff'])
            .catch(print),

        child: Label({
            label: '襤',
        }),
    }),

    center_widget: CursorBox({
        class_name: 'reboot button',
        on_primary_click_release: () => execAsync(['systemctl', 'reboot'])
            .catch(print),

        child: Label({
            label: '勒',
        }),
    }),

    end_widget: CursorBox({
        class_name: 'logout button',
        on_primary_click_release: () => Hyprland.sendMessage('dispatch exit')
            .catch(print),

        child: Label({
            label: '',
        }),
    }),
});

export default () => PopupWindow({
    name: 'powermenu',
    child: PowermenuWidget(),
});

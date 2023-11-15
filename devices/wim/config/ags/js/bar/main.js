import { Window, CenterBox, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator      from '../misc/separator.js';
import CurrentWindow  from './current-window.js';
import Workspaces     from './workspaces.js';
import OskToggle      from './osk-toggle.js';
import TabletToggle   from './tablet-toggle.js';
import QsToggle       from './quick-settings.js';
import NotifButton    from './notif-button.js';
import Clock          from './clock.js';
import SysTray        from './systray.js';
import Battery        from './battery.js';
import Brightness     from './brightness.js';
import Audio          from './audio.js';
import KeyboardLayout from './keyboard-layout.js';

import Revealer from './fullscreen.js';


export default () => Window({
    name: 'bar',
    layer: 'overlay',
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Revealer({
        child: CenterBox({
            className: 'bar',
            vertical: false,

            startWidget: Box({
                hpack: 'start',
                children: [

                    OskToggle(),

                    Separator(12),

                    TabletToggle(),

                    Separator(12),

                    SysTray(),

                    Audio(),

                    Separator(12),

                    Brightness(),

                    Separator(12),

                    Workspaces(),

                ],
            }),

            centerWidget: Box({
                children: [
                    Separator(12),

                    CurrentWindow(),

                    Separator(12),
                ],
            }),

            endWidget: Box({
                hpack: 'end',
                children: [
                    Battery(),

                    Separator(12),

                    KeyboardLayout(),

                    Separator(12),

                    Clock(),

                    Separator(12),

                    NotifButton(),

                    Separator(12),

                    QsToggle(),
                ],
            }),
        }),
    }),
});

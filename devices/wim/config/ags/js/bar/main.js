import { Window, CenterBox, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator      from '../misc/separator.js';
import CurrentWindow  from './buttons/current-window.js';
import Workspaces     from './buttons/workspaces.js';
import OskToggle      from './buttons/osk-toggle.js';
import TabletToggle   from './buttons/tablet-toggle.js';
import QsToggle       from './buttons/quick-settings.js';
import NotifButton    from './buttons/notif-button.js';
import Clock          from './buttons/clock.js';
import SysTray        from './buttons/systray.js';
import Battery        from './buttons/battery.js';
import Brightness     from './buttons/brightness.js';
import Audio          from './buttons/audio.js';
import KeyboardLayout from './buttons/keyboard-layout.js';

import BarReveal from './fullscreen.js';


export default () => Window({
    name: 'bar',
    layer: 'overlay',
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: BarReveal({
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

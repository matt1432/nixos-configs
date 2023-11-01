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
import Revealer       from './fullscreen.js';
//import KeyboardLayout from './keyboard-layout.js';


export const BgGradient = () => Window({
    name: 'bg-gradient',
    layer: 'background',
    anchor: ['top', 'bottom', 'left', 'right'],
    style: `
        background-image: -gtk-gradient (linear,
                          left top, left bottom,
                          from(rgba(0, 0, 0, 0.5)),
                          to(rgba(0, 0, 0, 0)));
    `,
});

export const Bar = () => Window({
    name: 'bar',
    layer: 'overlay',
    anchor: ['top', 'left', 'right'],
    exclusive: true,
    child: Revealer({
        child: CenterBox({
            className: 'bar',
            vertical: false,

            startWidget: Box({
                halign: 'start',
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
                halign: 'end',
                children: [
                    Battery(),

                    Separator(12),

                    //KeyboardLayout(),

                    //Separator(12),

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

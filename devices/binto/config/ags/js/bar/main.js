import { Box, CenterBox, Window } from 'resource:///com/github/Aylur/ags/widget.js';

import SysTray from 'file:///home/matt/.nix/devices/wim/config/ags/js/bar/buttons/systray.js';
import Separator from 'file:///home/matt/.nix/devices/wim/config/ags/js/misc/separator.js';
import NotifButton from 'file:///home/matt/.nix/devices/wim/config/ags/js/bar/buttons/notif-button.js';
import Clock from './buttons/clock.js';

const PADDING = 20;


export default () => Window({
    name: 'bar',
    layer: 'overlay',
    exclusivity: 'exclusive',
    anchor: ['bottom', 'left', 'right'],
    monitor: 1,

    child: Box({
        vertical: true,
        children: [
            CenterBox({
                className: 'bar',
                start_widget: Box({
                    hpack: 'start',
                    children: [
                        Separator(PADDING),

                        SysTray(),
                    ],
                }),

                center_widget: Box({
                    children: [],
                }),

                end_widget: Box({
                    hpack: 'end',
                    children: [
                        NotifButton(),
                        Separator(PADDING/2),
                        Clock(),

                        Separator(PADDING),
                    ],
                }),
            }),
            Separator(PADDING, {vertical: true}),
        ],
    }),
});

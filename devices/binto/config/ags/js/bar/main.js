import { Box, CenterBox, Window } from 'resource:///com/github/Aylur/ags/widget.js';

import SysTray from 'file:///home/matt/.nix/devices/wim/config/ags/js/bar/buttons/systray.js';
import NotifButton from 'file:///home/matt/.nix/devices/wim/config/ags/js/bar/buttons/notif-button.js';
import Clock from './buttons/clock.js';

export default () => Window({
    name: 'bar',
    layer: 'overlay',
    exclusivity: 'exclusive',
    anchor: ['bottom', 'left', 'right'],
    monitor: 1,

    child: CenterBox({
        start_widget: Box({
            hpack: 'start',
            children: [
                SysTray(),
            ],
        }),

        center_widget: Box({
            hpack: 'center',
        }),

        end_widget: Box({
            hpack: 'end',
            children: [
                NotifButton(),
                Clock(),
            ],
        }),
    }),
});

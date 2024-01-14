import { Box, CenterBox, Window } from 'resource:///com/github/Aylur/ags/widget.js';

import SysTray from '../../../../../wim/config/ags/ts/bar/items/systray.ts';
import Separator from '../../../../../wim/config/ags/ts/misc/separator.ts';
import NotifButton from
    '../../../../../wim/config/ags/ts/bar/items/notif-button.ts';
import Clock from './buttons/clock.ts';

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
                class_name: 'bar',
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
                        Separator(PADDING / 2),
                        Clock(),

                        Separator(PADDING),
                    ],
                }),
            }),
            Separator(PADDING, { vertical: true }),
        ],
    }),
});

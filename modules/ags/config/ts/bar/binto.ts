const { Box, CenterBox, Window } = Widget;

import Separator from '../misc/separator.ts';

import Clock from './items/clock.ts';
import NotifButton from './items/notif-button.ts';
import RazerStats from './items/razer-stats.ts';
import SysTray from './items/systray.ts';

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

                        Separator(PADDING / 2 / 2),

                        RazerStats(),
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

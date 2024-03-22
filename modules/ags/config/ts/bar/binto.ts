const { Box, CenterBox } = Widget;

import Separator from '../misc/separator.ts';

import BarRevealer from './fullscreen.ts';

import Clock from './items/clock.ts';
import NotifButton from './items/notif-button.ts';
import RazerStats from './items/razer-stats.ts';
import SysTray from './items/systray.ts';

const PADDING = 20;

export default () => BarRevealer({
    monitor: 1,
    exclusivity: 'exclusive',
    anchor: ['bottom', 'left', 'right'],
    transition: 'slide_up',
    bar: Box({
        vertical: true,
        children: [
            CenterBox({
                class_name: 'bar',
                hexpand: true,

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

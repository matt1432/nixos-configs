const { Box, CenterBox } = Widget;

import Separator from '../misc/separator.ts';
import { get_gdkmonitor_from_desc } from '../lib.ts';

import BarRevealer from './fullscreen.ts';

import Clock from './items/cal-opener.ts';
import CurrentWindow from './items/current-window';
import NotifButton from './items/notif-button.ts';
import SysTray from './items/systray.ts';

const PADDING = 20;

export default () => BarRevealer({
    gdkmonitor: get_gdkmonitor_from_desc('desc:Acer Technologies Acer K212HQL T3EAA0014201'),
    exclusivity: 'exclusive',
    anchor: ['bottom', 'left', 'right'],
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
                    ],
                }),

                center_widget: Box({
                    children: [
                        CurrentWindow(),

                        Separator(PADDING / 2),
                    ],
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

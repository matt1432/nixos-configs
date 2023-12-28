import { Window, CenterBox, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../misc/separator.js';

import Battery from './items/battery.js';
import Clock from './items/clock.js';
import CurrentWindow from './items/current-window.js';
import Heart from './items/heart.js';
import NotifButton from './items/notif-button.js';
import OskToggle from './items/osk-toggle.js';
import QsToggle from './items/quick-settings.js';
import SysTray from './items/systray.js';
import TabletToggle from './items/tablet-toggle.js';
import Workspaces from './items/workspaces.js';

import BarReveal from './fullscreen.js';

const SPACING = 12;


export default () => Window({
    name: 'bar',
    layer: 'overlay',
    anchor: ['top', 'left', 'right'],
    margins: [-1, 0, 0, 0],
    exclusivity: 'exclusive',
    child: BarReveal({
        child: CenterBox({
            css: 'margin: 6px 5px 5px 5px',
            class_name: 'bar',

            start_widget: Box({
                hpack: 'start',
                children: [

                    OskToggle(),

                    Separator(SPACING),

                    TabletToggle(),

                    Separator(SPACING),

                    SysTray(),

                    Workspaces(),

                    Separator(SPACING),

                    CurrentWindow(),

                ],
            }),

            center_widget: Box({
                children: [
                    Separator(SPACING),

                    Clock(),

                    Separator(SPACING),
                ],
            }),

            end_widget: Box({
                hpack: 'end',
                children: [
                    Heart(),

                    Separator(SPACING),

                    Battery(),

                    Separator(SPACING),

                    NotifButton(),

                    Separator(SPACING),

                    QsToggle(),
                ],
            }),
        }),
    }),
});

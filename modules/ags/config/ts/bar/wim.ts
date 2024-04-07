const { CenterBox, Box } = Widget;

import Separator from '../misc/separator.ts';

import Battery from './items/battery.ts';
import Clock from './items/cal-opener.ts';
import CurrentWindow from './items/current-window.ts';
import Heart from './items/heart.ts';
import NotifButton from './items/notif-button.ts';
import OskToggle from './items/osk-toggle.ts';
import QsToggle from './items/quick-settings.ts';
import SysTray from './items/systray.ts';
import TabletToggle from './items/tablet-toggle.ts';
import Workspaces from './items/workspaces.ts';

import BarRevealer from './fullscreen.ts';

const SPACING = 12;


export default () => BarRevealer({
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    bar: CenterBox({
        css: 'margin: 5px 5px 5px 5px',
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
});

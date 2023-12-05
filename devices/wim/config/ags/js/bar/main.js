import { Window, CenterBox, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../misc/separator.js';

import Brightness from './buttons/brightness.js';
import Clock from './buttons/clock.js';
import CurrentWindow from './buttons/current-window.js';
import NotifButton from './buttons/notif-button.js';
import OskToggle from './buttons/osk-toggle.js';
import QsToggle from './buttons/quick-settings.js';
import SysTray from './buttons/systray.js';
import TabletToggle from './buttons/tablet-toggle.js';
import Workspaces from './buttons/workspaces.js';

import BarReveal from './fullscreen.js';

const SPACING = 12;


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

                    Separator(SPACING),

                    TabletToggle(),

                    Separator(SPACING),

                    SysTray(),

                    Brightness(),

                    Separator(SPACING),

                    Workspaces(),

                ],
            }),

            centerWidget: Box({
                children: [
                    Separator(SPACING),

                    CurrentWindow(),

                    Separator(SPACING),
                ],
            }),

            endWidget: Box({
                hpack: 'end',
                children: [
                    Clock(),

                    Separator(SPACING),

                    NotifButton(),

                    Separator(SPACING),

                    QsToggle(),
                ],
            }),
        }),
    }),
});

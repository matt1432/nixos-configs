import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';
import Separator from '../../misc/separator.ts';

const SPACING = 8;


export default () => Box({
    children: [
        Separator(SPACING / 2),

        Icon({ size: 30 })
            .hook(Hyprland.active.client, (self) => {
                const app = Applications
                    .query(Hyprland.active.client.class)[0];

                if (app) {
                    self.icon = app.icon_name || '';
                    self.visible = Hyprland.active.client.title !== '';
                }
            }),

        Separator(SPACING),

        Label({
            css: 'color: #CBA6F7; font-size: 18px',
            truncate: 'end',
            label: Hyprland.active.client.bind('title'),
        }),
    ],
});

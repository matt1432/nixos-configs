const Applications = await Service.import('applications');
const Hyprland = await Service.import('hyprland');
const { Box, Icon, Label } = Widget;

import Separator from '../../misc/separator.ts';

const SPACING = 8;


export default () => Box({
    class_name: 'current-window',

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

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

                self.icon = app?.icon_name || '';
            }),

        Separator(SPACING),

        Label({
            truncate: 'end',
            label: Hyprland.active.client.bind('title'),
        }),
    ],
}).hook(Hyprland.active.client, (self) => {
    self.visible = Hyprland.active.client.title !== '';
});

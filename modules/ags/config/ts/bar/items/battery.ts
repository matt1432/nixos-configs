import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

import { Label, Icon, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.ts';

const LOW_BATT = 20;
const SPACING = 5;


export default () => Box({
    class_name: 'toggle-off battery',

    children: [
        Icon({
            class_name: 'battery-indicator',
            icon: Battery.bind('icon_name'),
        }).hook(Battery, (self) => {
            self.toggleClassName('charging', Battery.charging);
            self.toggleClassName('charged', Battery.charged);
            self.toggleClassName('low', Battery.percent < LOW_BATT);
        }),

        Separator(SPACING),

        Label({
            label: Battery.bind('percent')
                .transform((v) => `${v}%`),
        }),
    ],
});

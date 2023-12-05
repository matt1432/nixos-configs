import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

import { Label, Icon, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const LOW_BATT = 20;


const Indicator = () => Icon({
    className: 'battery-indicator',

    binds: [['icon', Battery, 'icon-name']],

    connections: [[Battery, (self) => {
        self.toggleClassName('charging', Battery.charging);
        self.toggleClassName('charged', Battery.charged);
        self.toggleClassName('low', Battery.percent < LOW_BATT);
    }]],
});

const LevelLabel = (props) => Label({
    ...props,
    className: 'label',

    connections: [[Battery, (self) => {
        self.label = `${Battery.percent}%`;
    }]],
});

const SPACING = 5;

export default () => Box({
    className: 'toggle-off battery',

    children: [
        Indicator(),
        Separator(SPACING),
        LevelLabel(),
    ],
});

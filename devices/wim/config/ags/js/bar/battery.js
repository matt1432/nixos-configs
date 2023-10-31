import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import { Label, Icon, Stack, Box } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../misc/separator.js';

const icons = charging => ([
    ...Array.from({ length: 10 }, (_, i) => i * 10).map(i => ([
        `${i}`, Icon({
            className: `${i} ${charging ? 'charging' : 'discharging'}`,
            icon: `battery-level-${i}${charging ? '-charging' : ''}-symbolic`,
        }),
    ])),
    ['100', Icon({
        className: `100 ${charging ? 'charging' : 'discharging'}`,
        icon: `battery-level-100${charging ? '-charged' : ''}-symbolic`,
    })],
]);


const Indicators = charging => Stack({
    items: icons(charging),
    connections: [[Battery, stack => {
        stack.shown = `${Math.floor(Battery.percent / 10) * 10}`;
    }]],
});

const Indicator = ({
    charging = Indicators(true),
    discharging = Indicators(false),
    ...props
} = {}) => Stack({
    ...props,
    className: 'battery-indicator',
    items: [
        ['true', charging],
        ['false', discharging],
    ],
    connections: [[Battery, stack => {
        stack.shown = `${Battery.charging || Battery.charged}`;
        stack.toggleClassName('charging', Battery.charging);
        stack.toggleClassName('charged', Battery.charged);
        stack.toggleClassName('low', Battery.percent < 20);
    }]],
});

const LevelLabel = props => Label({
    ...props,
    className: 'label',
    connections: [[Battery, self => self.label = `${Battery.percent}%`]],
});

export default () => Box({
    className: 'toggle-off battery',
    children: [
        Indicator(),
        Separator(5),
        LevelLabel(),
    ],
});

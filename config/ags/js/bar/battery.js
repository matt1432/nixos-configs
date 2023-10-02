import { Battery, Widget } from '../../imports.js';
const { Label, Icon, Stack, Box } = Widget;

import { Separator } from '../misc/separator.js';

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
  ...params
} = {}) => Stack({
  ...params,
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

const LevelLabel = params => Label({
  ...params,
  className: 'label',
  connections: [[Battery, label => label.label = `${Battery.percent}%`]],
});

export const BatteryIndicator = Box({
  className: 'toggle-off battery',
  children: [
    Indicator(),
    Separator(5),
    LevelLabel(),
  ],
});

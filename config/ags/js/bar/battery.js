const { Label, Icon, Stack, ProgressBar, Overlay, Box } = ags.Widget;
const { exec } = ags.Utils;

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
  connections: [[1000, stack => {
    stack.shown = `${Math.floor(exec('cat /sys/class/power_supply/BAT0/capacity') / 10) * 10}`;
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
  connections: [[1000, stack => {
    const charging = exec('cat /sys/class/power_supply/BAT0/status') == 'Charging';
    const charged = exec('cat /sys/class/power_supply/BAT0/capacity') == 100;
    stack.shown = `${charging || charged}`;
    stack.toggleClassName('charging', charging);
    stack.toggleClassName('charged', charged);
    stack.toggleClassName('low', exec('cat /sys/class/power_supply/BAT0/capacity') < 30);
  }]],
});

const LevelLabel = params => Label({
  ...params,
  className: 'label',
  connections: [[1000, label => label.label = `${exec('cat /sys/class/power_supply/BAT0/capacity')}%`]],
});

export const BatteryIndicator = Box({
  className: 'toggle-off battery',
  children: [
    Indicator(),
    Separator(5),
    LevelLabel(),
  ],
});

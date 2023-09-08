const { Label, Icon, Stack, ProgressBar, Overlay, Box } = ags.Widget;
import { Separator } from '../common.js';
const { exec } = ags.Utils;

const icons = charging => ([
  ...Array.from({ length: 9 }, (_, i) => i * 10).map(i => ([
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

export const Indicator = ({
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
  connections: [[1000, stack => {
    const charging = exec('cat /sys/class/power_supply/BAT0/status') == 'Charging';
    const charged = exec('cat /sys/class/power_supply/BAT0/capacity') == 100;
    stack.shown = `${charging || charged}`;
    stack.toggleClassName('charging', charging);
    stack.toggleClassName('charged', charged);
    stack.toggleClassName('low', exec('cat /sys/class/power_supply/BAT0/capacity') < 30);
  }]],
});

export const LevelLabel = props => Label({
  ...props,
  className: 'label',
  connections: [[1000, label => label.label = `${exec('cat /sys/class/power_supply/BAT0/capacity')}%`]],
});

export const BatteryLabel = () => Box({
  className: 'toggle-off battery',
  children: [
    Indicator(),
    Separator(5),
    LevelLabel(),
  ],
});

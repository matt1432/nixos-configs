const { Label, Icon, Stack, ProgressBar, Overlay, Box } = ags.Widget;
import { Separator } from '../common.js';
const { exec } = ags.Utils;

const Indicator = props => Icon({
  ...props,
  size: 28,
  style: 'margin-left: -5px',
  icon: 'display-brightness-symbolic',
});

const LevelLabel = props => Label({
  ...props,
  className: 'label',
  connections: [[200, label => label.label = `${Math.floor(exec('brightnessctl get') / 2.55)}%`]],
});

const BrightnessModule = () => Overlay({
  child: ProgressBar({
    className: 'toggle-off brightness',
    connections: [
      [ 200, progress => {
        let br = exec('brightnessctl get') / 255;
        if (br > 0.33) {
          progress.value = br;
        }
        else {
          progress.value = 0.33;
        }
      }]
    ],
  }),
  overlays: [
    Box({
      className: 'battery',
      style: 'color: #CBA6F7;',
      children: [
        Indicator(),
        Separator(2),
        LevelLabel(),
      ],
    }),
  ],
});

export const Brightness = BrightnessModule();

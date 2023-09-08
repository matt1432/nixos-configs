const { Label, Icon, Stack, ProgressBar, Overlay, Box } = ags.Widget;
import { Separator } from '../common.js';
const { exec } = ags.Utils;

const Indicator = props => Label({
  ...props,
  label: '',
  connections: [[500, icon => {
    const br = `${exec('brightnessctl get')}`;
         if (br <= 3) icon.label = "";
    else if (br <= 38) icon.label = "";
    else if (br <= 77) icon.label = "";
    else if (br <= 115) icon.label = "";
    else if (br <= 153) icon.label = "";
    else if (br <= 191) icon.label = "";
    else if (br <= 230) icon.label = "";
                   else icon.label = "";
  }]],
});

const LevelLabel = props => Label({
  ...props,
  className: 'label',
  connections: [[500, label => label.label = `${Math.floor(exec('brightnessctl get') / 2.55)}%`]],
});

const BrightnessModule = () => Box({
  className: 'toggle-off battery',
  children: [
    Indicator(),
    Separator(12),
    LevelLabel(),
  ],
});

export const Brightness = BrightnessModule();

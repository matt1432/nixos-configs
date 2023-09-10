const { Label, Icon, Stack, ProgressBar, Overlay, Box } = ags.Widget;
const { exec } = ags.Utils;
import { Separator } from '../common.js';
import { Heart }     from './heart.js';

export const Brightness = Overlay({
  setup: widget => {
    widget.set_tooltip_text('Brightness');
  },
  child: ProgressBar({
    className: 'toggle-off brightness',
    connections: [
      [200, progress => {
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
      style: 'color: #CBA6F7;',
      children: [
        Separator(25),
        Heart,
      ],
    }),
  ],
});

import { Utils, Widget } from '../../imports.js';
const { ProgressBar, Overlay, Box } = Widget;

import { Separator } from '../misc/separator.js';
import { Heart }     from './heart.js';


export const Brightness = Overlay({
  setup: widget => {
    widget.set_tooltip_text('Brightness');
  },
  child: ProgressBar({
    className: 'toggle-off brightness',
    connections: [
      [200, progress => {
        Utils.execAsync('brightnessctl get').then(out => {
          let br = out / 255;
          if (br > 0.33) {
            progress.value = br;
          }
          else {
            progress.value = 0.33;
          }
        }).catch(print);
      }],
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

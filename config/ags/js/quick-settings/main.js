const { Window, CenterBox, Box, Label } = ags.Widget;

import { ButtonGrid } from './button-grid.js';
import { SliderBox } from './slider-box.js';
//import { Player } from 

export const QuickSettings = Window({
  name: 'quick-settings',
  layer: 'overlay',
  popup: true,
  anchor: 'top right',
  child: Box({
    className: 'qs-container',
    vertical: true,
    children: [
      
      Box({
        className: 'quick-settings',
        vertical: true,
        children: [

          Label({
            label: 'Control Center',
            className: 'title',
            halign: 'start',
            style: 'margin-left: 20px'
          }),

          ButtonGrid,

          SliderBox,

        ],
      }),

      //Player,

    ],
  }),
});

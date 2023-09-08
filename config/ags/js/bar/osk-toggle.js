const { Box, Label } = ags.Widget;
const { subprocess, exec } = ags.Utils;
const deflisten = subprocess;

import { EventBox } from '../common.js';

deflisten(
  ['bash', '-c', '$AGS_PATH/osk-toggle.sh getState'],
  (output) => {
    if (output == 'Running') {
      OskToggle.toggleClassName('toggle-on', true);
    } else {
      OskToggle.toggleClassName('toggle-on', false);
    }
  },
);
export const OskToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    subprocess(
      ['bash', '-c', '$AGS_PATH/osk-toggle.sh toggle'],
      (output) => {
        if (output == 'Running') {
          OskToggle.toggleClassName('toggle-on', false);
        } else {
          OskToggle.toggleClassName('toggle-on', true);
        }
      },
    );
  },
  child: Box({
    className: 'osk-toggle',
    vertical: false,

    children: [
      Label({
        label: " 󰌌 ",
      }),
    ],
  }),
});

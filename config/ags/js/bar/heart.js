const { Box, Label } = ags.Widget;
const { subprocess, exec } = ags.Utils;
const deflisten = subprocess;

import { EventBox } from '../common.js';

deflisten(
  ['bash', '-c', 'tail -f /home/matt/.config/.heart'],
  (output) => {
    Heart.child.children[0].label = ' ' + output;

    if (output == '󰣐') {
      Heart.toggleClassName('toggle-on', true);
    } else {
      Heart.toggleClassName('toggle-on', false);
    }
  },
);
export const Heart = EventBox({
  className: 'toggle-off',
  halign: 'center',
  onPrimaryClickRelease: () => {
    exec("bash -c '$AGS_PATH/heart.sh toggle'");
  },
  child: Box({
    className: 'heart-toggle',
    vertical: false,

    child: Label({
      label: '',
    }),
  }),
});

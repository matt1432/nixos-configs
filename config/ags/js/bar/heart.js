const { Box, Label } = ags.Widget;
const { subprocess, execAsync } = ags.Utils;
const deflisten = subprocess;

import { EventBox } from '../misc/cursorbox.js';

deflisten(
  ['bash', '-c', 'tail -f /home/matt/.config/.heart'],
  (output) => {
    Heart.child.children[0].label = ' ' + output;
  },
);
export const Heart = EventBox({
  halign: 'center',
  onPrimaryClickRelease: () => {
    execAsync(['bash', '-c', '$AGS_PATH/heart.sh toggle']).catch(print);
  },
  child: Box({
    className: 'heart-toggle',
    vertical: false,

    child: Label({
      label: '',
    }),
  }),
});

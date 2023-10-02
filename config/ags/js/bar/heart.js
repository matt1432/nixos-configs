import { Utils, Widget } from '../../imports.js';
const { Box, Label } = Widget;
const { subprocess, execAsync } = Utils;

import { EventBox } from '../misc/cursorbox.js';


subprocess(
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

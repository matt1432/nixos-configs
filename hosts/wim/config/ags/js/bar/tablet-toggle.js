import { Utils, Widget } from '../../imports.js';
const { Box, Label } = Widget;
const { subprocess } = Utils;

import EventBox from '../misc/cursorbox.js';


export default () => EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: self => {
    subprocess(
      ['bash', '-c', '$AGS_PATH/tablet-toggle.sh toggle'],
      (output) => self.toggleClassName('toggle-on', output == 'Tablet'),
    );
  },
  child: Box({
    className: 'tablet-toggle',
    vertical: false,
    child: Label({
      label: " 󰦧 ",
    }),
  }),
});

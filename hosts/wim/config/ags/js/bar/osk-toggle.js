import { Utils, Widget } from '../../imports.js';
const { Box, Label } = Widget;
const { subprocess } = Utils;

import EventBox from '../misc/cursorbox.js';


export default () => EventBox({
  className: 'toggle-off',
  setup: self => {
    subprocess(
      ['bash', '-c', '$AGS_PATH/osk-toggle.sh getState'],
      (output) => self.toggleClassName('toggle-on', output === 'Running'),
    );
  },

  onPrimaryClickRelease: self => {
    subprocess(
      ['bash', '-c', '$AGS_PATH/osk-toggle.sh toggle'],
      (output) => self.toggleClassName('toggle-on', output !== 'Running'),
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

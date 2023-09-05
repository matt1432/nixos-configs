const { Box, Label } = ags.Widget;
const { subprocess } = ags.Utils;

import { EventBox } from '../common.js';

export const TabletToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    subprocess(
      ['bash', '-c', '/home/matt/.nix/config/ags/bin/tablet-toggle.sh toggle'],
      (output) => {
        print(output)
        if (output == 'Tablet') {
          TabletToggle.toggleClassName('toggle-on', true);
        } else {
          TabletToggle.toggleClassName('toggle-on', false);
        }
      },
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

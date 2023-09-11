const { Box, Label } = ags.Widget;
const { subprocess } = ags.Utils;

import { EventBox } from '../misc/cursorbox.js';

export const TabletToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    subprocess(
      ['bash', '-c', '$AGS_PATH/tablet-toggle.sh toggle'],
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

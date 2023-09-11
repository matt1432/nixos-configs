const { Box, Label } = ags.Widget;
const { subprocess } = ags.Utils;
const deflisten = subprocess;

import { EventBox } from '../misc/cursorbox.js';

deflisten(
  ['bash', '-c', '$AGS_PATH/qs-toggle.sh state'],
  (output) => {
    print(output)
    if (output == 'On') {
      QsToggle.toggleClassName('toggle-on', false);
    } else {
      QsToggle.toggleClassName('toggle-on', true);
    }
  },
);
export const QsToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    subprocess(
      ['bash', '-c', '$AGS_PATH/qs-toggle.sh toggle'],
      (output) => {
        print(output)
        if (output == 'On') {
          QsToggle.toggleClassName('toggle-on', true);
        } else {
          QsToggle.toggleClassName('toggle-on', false);
        }
      },
    );
  },
  child: Box({
    className: 'quick-settings-toggle',
    vertical: false,
    child: Label({
      label: "  ",
    }),
  }),
});

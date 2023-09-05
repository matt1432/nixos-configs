const { Box, Label } = ags.Widget;
const { subprocess } = ags.Utils;
import { EventBox } from '../common.js';
const deflisten = subprocess;

deflisten(
  ['bash', '-c', '/home/matt/.nix/config/ags/bin/qs-toggle.sh state'],
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
      ['bash', '-c', '/home/matt/.nix/config/ags/bin/qs-toggle.sh toggle'],
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

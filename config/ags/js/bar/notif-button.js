const { Box, Label } = ags.Widget;
const { subprocess } = ags.Utils;
import { EventBox } from '../common.js';
const deflisten = subprocess;

deflisten(
  ['bash', '-c', '$AGS_PATH/notif.sh icon'],
  (output) => {
    NotifButton.child.children[0].label = '     ' + output;
  },
);
deflisten(
  ['bash', '-c', '$AGS_PATH/notif-toggle.sh state'],
  (output) => {
    print(output)
    if (output == 'On') {
      NotifButton.toggleClassName('toggle-on', false);
    } else {
      NotifButton.toggleClassName('toggle-on', true);
    }
  },
);
export const NotifButton = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    subprocess(
      ['bash', '-c', '$AGS_PATH/notif-toggle.sh toggle'],
      (output) => {
        print(output)
        if (output == 'On') {
          NotifButton.toggleClassName('toggle-on', true);
        } else {
          NotifButton.toggleClassName('toggle-on', false);
        }
      },
    );
  },
  child: Box({
    className: 'notif-panel',
    vertical: false,
    child: Label({
      label: "",
    }),
  }),
});

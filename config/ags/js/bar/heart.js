

import { EventBox } from '../common.js';

ags.Utils.subprocess(
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
  onPrimaryClickRelease: function() {
    ags.Utils.exec('/home/matt/.nix/config/ags/bin/heart.sh toggle');
  },
  child: ags.Widget.Box({
    className: 'heart-toggle',
    vertical: false,

    child: ags.Widget.Label({
      label: '',
    }),
  }),
});

import { Separator, EventBox } from '../common.js';

ags.Utils.subprocess(
  ['bash', '-c', '/home/matt/.nix/config/ags/scripts/osk-toggle.sh getState'],
  (output) => {
    if (output == 'Running') {
      OskToggle.toggleClassName('toggle-on', true);
    } else {
      OskToggle.toggleClassName('toggle-on', false);
    }
  },
);
export const OskToggle = EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    ags.Utils.subprocess(
      ['bash', '-c', '/home/matt/.nix/config/ags/bin/osk-toggle.sh toggle'],
      (output) => {
        if (output == 'Running') {
          OskToggle.toggleClassName('toggle-on', false);
        } else {
          OskToggle.toggleClassName('toggle-on', true);
        }
      },
    );
  },
  child: ags.Widget.Box({
    className: 'osk-toggle',
    vertical: false,

    children: [
      ags.Widget.Label({
        label: " 󰌌 ",
      }),
    ],
  }),
});

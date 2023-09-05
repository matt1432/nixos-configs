import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();
import { CurrentWindow } from './current-window.js';
import { Workspaces } from './workspaces.js';

const Separator = width => ags.Widget.Box({
  style: `min-width: ${width}px;`,
});

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
const OskToggle = ags.Widget.EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    ags.Utils.subprocess(
      ['bash', '-c', '/home/matt/.nix/config/ags/scripts/osk-toggle.sh toggle'],
      (output) => {
        if (output == 'Running') {
          OskToggle.toggleClassName('toggle-on', false);
        } else {
          OskToggle.toggleClassName('toggle-on', true);
        }
      },
    );
  },
  onHover: box => {
    box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
  },
  onHoverLost: box => {
    box.window.set_cursor(null);
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

ags.Utils.subprocess(
  ['bash', '-c', 'tail -f /home/matt/.config/.heart'],
  (output) => {
    HeartToggle.child.children[0].label = ' ' + output;

    if (output == '󰣐') {
      HeartToggle.toggleClassName('toggle-on', true);
    } else {
      HeartToggle.toggleClassName('toggle-on', false);
    }
  },
);
const HeartToggle = ags.Widget.EventBox({
  className: 'toggle-off',
  halign: 'center',
  onPrimaryClickRelease: function() {
    ags.Utils.exec('/home/matt/.nix/config/ags/scripts/heart.sh toggle');
  },
  onHover: box => {
    box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
  },
  onHoverLost: box => {
    box.window.set_cursor(null);
  },
  child: ags.Widget.Box({
    className: 'heart-toggle',
    vertical: false,

    child: ags.Widget.Label({
      label: '',
    }),
  }),
});

export const LeftBar = ags.Widget.Window({
  name: 'left-bar',
  layer: 'overlay',
  anchor: 'top left right',
  exclusive: true,

  child: ags.Widget.CenterBox({
    className: 'transparent',
    halign: 'fill',
    style: 'margin-top: 5px; margin-left: 5px;',
    vertical: false,
    
    children: [

      ags.Widget.Box({
        halign: 'start',
        children: [

          OskToggle,
  
          Separator(12),

          ags.Widget.EventBox({
            className: 'toggle-off',
            onPrimaryClickRelease: '',
            onHover: box => {
              box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
            },
            onHoverLost: box => {
              box.window.set_cursor(null);
            },
            child: ags.Widget.Box({
              className: 'tablet-toggle',
              vertical: false,

              child: ags.Widget.Label({
                label: " 󰦧 ",
              }),
            }),
          }),
      
          Separator(12),

          HeartToggle,

          Separator(12),

          Workspaces(),

        ],
      }),

      CurrentWindow,

      ags.Widget.Box({
        halign: 'end',
        style: 'background: red; min-width: 100px; min-height: 40px',
      }),
    ],
  }),
});

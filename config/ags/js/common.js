export const Closer = ags.Widget.Window({
  name: 'closer',
  popup: true,
  layer: 'top',
  anchor: 'top bottom left right',

  child: ags.Widget.EventBox({
    onPrimaryClickRelease: () => {
      ags.App.closeWindow('powermenu');
      ags.App.closeWindow('closer');
    },
  }),
});

export const Separator = width => ags.Widget.Box({
  style: `min-width: ${width}px;`,
});

import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();

export const EventBox = ({ reset = true, ...params }) => ags.Widget.EventBox({
  ...params,
  onHover: box => {
    if (! box.child.sensitive || ! box.sensitive) {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'not-allowed'));
    }
    else {
      box.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
    }
  },
  onHoverLost: box => {
    if (reset)
      box.window.set_cursor(null);
  },
});

import { Widget } from '../../imports.js';

import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();


export const EventBox = ({ reset = true, ...params }) => Widget.EventBox({
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

export const Button = ({ reset = true, ...params }) => Widget.Button({
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

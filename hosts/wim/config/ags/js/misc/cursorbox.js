import { Widget } from '../../imports.js';

import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();


export default ({
  type = "EventBox",
  reset = true,
  ...props
}) => {
  if (type === "EventBox") {
    return Widget.EventBox({
      ...props,
      onHover: self => {
        if (!self.child.sensitive || !self.sensitive) {
          self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'not-allowed'));
        }
        else {
          self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
        }
      },
      onHoverLost: self => {
        if (reset)
          self.window.set_cursor(null);
      },
    });
  }
  else {
    return Widget.Button({
      ...props,
      onHover: self => {
        if (!self.child.sensitive || !self.sensitive) {
          self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'not-allowed'));
        }
        else {
          self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
        }
      },
      onHoverLost: self => {
        if (reset)
          self.window.set_cursor(null);
      },
    });
  }
}

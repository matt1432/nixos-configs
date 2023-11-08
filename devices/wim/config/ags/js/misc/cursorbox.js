import { Button, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

import Gdk from 'gi://Gdk';
const display = Gdk.Display.get_default();


export default ({
    isButton = false,
    reset = true,
    onHover = () => {},
    onHoverLost = () => {},
    ...props
}) => {
    if (!isButton) {
        return EventBox({
            ...props,
            onHover: self => {
                if (!self.child.sensitive || !self.sensitive)
                    self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'not-allowed'));

                else
                    self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));

                onHover(self);
            },
            onHoverLost: self => {
                if (reset)
                    self.window.set_cursor(null);

                onHoverLost(self);
            },
        });
    }
    else {
        return Button({
            ...props,
            onHover: self => {
                if (!self.child.sensitive || !self.sensitive)
                    self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'not-allowed'));
                else
                    self.window.set_cursor(Gdk.Cursor.new_from_name(display, 'pointer'));
            },
            onHoverLost: self => {
                if (reset)
                    self.window.set_cursor(null);
            },
        });
    }
};

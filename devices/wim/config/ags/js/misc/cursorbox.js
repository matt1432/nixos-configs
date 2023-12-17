import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Button, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

import Gtk from 'gi://Gtk';


// TODO: wrap in another EventBox for disabled cursor
export default ({
    isButton = false,
    onPrimaryClickRelease = () => { /**/ },
    ...props
}) => {
    // Make this variable to know if the function should
    // be executed depending on where the click is released
    const CanRun = Variable(true);

    const properties = {
        ...props,
        cursor: 'pointer',
        onPrimaryClickRelease: (self) => {
            // Every click, do a one shot connect to
            // CanRun to wait for location of click
            const id = CanRun.connect('changed', () => {
                if (CanRun.value) {
                    onPrimaryClickRelease(self);
                }

                CanRun.disconnect(id);
            });
        },
    };

    let widget;

    if (isButton) {
        widget = Button(properties);
    }
    else {
        widget = EventBox(properties);
    }

    const gesture = Gtk.GestureLongPress.new(widget);

    widget.hook(gesture, () => {
        const pointer = gesture.get_point(null);
        const x = pointer[1];
        const y = pointer[2];

        if ((!x || !y) || (x === 0 && y === 0)) {
            return;
        }

        CanRun.value = !(
            x > widget.get_allocated_width() ||
            y > widget.get_allocated_height()
        );
    }, 'end');

    return widget;
};

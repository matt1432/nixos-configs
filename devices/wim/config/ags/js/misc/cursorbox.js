import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Button, EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

import Gtk from 'gi://Gtk';


// TODO: wrap in another EventBox for disabled cursor
/**
 * @typedef {import('types/widget.js').Widget} Widget
 * @typedef {Widget & Object} CursorProps
 * @property {boolean=} isButton
 * @property {function(Widget):void=} onPrimaryClickRelease
 *
 * @param {CursorProps} obj
 */
export default ({
    isButton = false,

    onPrimaryClickRelease = (self) => {
        self;
    },
    ...props
}) => {
    // Make this variable to know if the function should
    // be executed depending on where the click is released
    const CanRun = Variable(true);

    let widgetFunc;

    if (isButton) {
        widgetFunc = Button;
    }
    else {
        widgetFunc = EventBox;
    }

    const widget = widgetFunc({
        ...props,
        cursor: 'pointer',
        on_primary_click_release: (self) => {
            // Every click, do a one shot connect to
            // CanRun to wait for location of click
            const id = CanRun.connect('changed', () => {
                if (CanRun.value) {
                    onPrimaryClickRelease(self);
                }

                CanRun.disconnect(id);
            });
        },
    });

    const gesture = Gtk.GestureLongPress.new(widget);

    // @ts-expect-error
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

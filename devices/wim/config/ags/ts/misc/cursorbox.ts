import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

const { Gtk, Gdk } = imports.gi;
const display = Gdk.Display.get_default();

import * as EventBoxTypes from 'types/widgets/eventbox';
type CursorBox = EventBoxTypes.EventBoxProps & {
    on_primary_click_release?(self: EventBoxTypes.default): void;
    on_hover?(self: EventBoxTypes.default): void;
    on_hover_lost?(self: EventBoxTypes.default): void;
};


export default ({
    on_primary_click_release = () => {/**/},
    on_hover = () => {/**/},
    on_hover_lost = () => {/**/},
    attribute,
    ...props
}: CursorBox) => {
    // Make this variable to know if the function should
    // be executed depending on where the click is released
    const CanRun = Variable(true);
    const Disabled = Variable(false);

    const cursorBox = EventBox({
        ...props,

        attribute: {
            ...attribute,
            disabled: Disabled,
        },

        on_primary_click_release: (self) => {
            // Every click, do a one shot connect to
            // CanRun to wait for location of click
            const id = CanRun.connect('changed', () => {
                if (CanRun.value && !Disabled.value) {
                    on_primary_click_release(self);
                }

                CanRun.disconnect(id);
            });
        },

    // OnHover
    }).on('enter-notify-event', (self) => {
        on_hover(self);

        self.window.set_cursor(Gdk.Cursor.new_from_name(
            display,
            Disabled.value ?
                'not-allowed' :
                'pointer',
        ));
        self.toggleClassName('hover', true);

    // OnHoverLost
    }).on('leave-notify-event', (self) => {
        on_hover_lost(self);

        self.window.set_cursor(null);
        self.toggleClassName('hover', false);

    // Disabled class
    }).hook(Disabled, (self) => {
        self.toggleClassName('disabled', Disabled.value);
    });

    const gesture = Gtk.GestureLongPress.new(cursorBox);

    cursorBox.hook(gesture, () => {
        const pointer = gesture.get_point(null);
        const x = pointer[1];
        const y = pointer[2];

        if ((!x || !y) || (x === 0 && y === 0)) {
            return;
        }

        CanRun.value = !(
            x > cursorBox.get_allocated_width() ||
            y > cursorBox.get_allocated_height()
        );
    }, 'end');

    return cursorBox;
};

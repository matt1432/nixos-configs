import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { EventBox } from 'resource:///com/github/Aylur/ags/widget.js';

const { Gtk } = imports.gi;


/**
 * @typedef {import('types/widgets/eventbox').EventBoxProps} EventBoxProps
 * @typedef {import('types/widgets/eventbox').default} EventBox
 *
 * @param {EventBoxProps & {
 *      on_primary_click_release?: function(EventBox):void
 * }} o
 */
export default ({
    attribute,
    on_primary_click_release = () => {/**/},
    ...props
}) => {
    // Make this variable to know if the function should
    // be executed depending on where the click is released
    const CanRun = Variable(true);
    const Disabled = Variable(false);

    let widget; // eslint-disable-line

    const wrapper = EventBox({
        cursor: 'pointer',

        attribute: {
            ...attribute,

            disabled: Disabled,

            get_child: () => widget.child,

            set_child: (new_child) => {
                widget.child = new_child;
            },
        },

    }).hook(Disabled, (self) => {
        self.cursor = Disabled.value ?
            'not-allowed' :
            'pointer';
    });

    widget = EventBox({
        ...props,
        sensitive: Disabled.bind().transform((v) => !v),

        on_primary_click_release: () => {
            // Every click, do a one shot connect to
            // CanRun to wait for location of click
            const id = CanRun.connect('changed', () => {
                if (CanRun.value) {
                    on_primary_click_release(wrapper);
                }

                CanRun.disconnect(id);
            });
        },
    });

    wrapper.child = widget;

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

    return wrapper;
};

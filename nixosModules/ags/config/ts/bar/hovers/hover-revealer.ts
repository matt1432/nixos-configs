const { Box, Revealer } = Widget;

import Gtk from 'gi://Gtk?version=3.0';

import Separator from '../../misc/separator.ts';
import CursorBox from '../../misc/cursorbox.ts';


export default ({
    class_name,
    icon,
    label,
    spacing = 5,
}) => {
    const hoverRevLabel = Revealer({
        transition: 'slide_right',
        attribute: {
            var: Variable(Box()),
        },

        child: Box({

            children: [
                Separator(spacing),

                label,
            ],
        }),
    });

    const widget = CursorBox({
        on_hover: () => {
            hoverRevLabel.reveal_child = true;
            hoverRevLabel.attribute.var.value.set_state_flags(Gtk.StateFlags.PRELIGHT, false);
        },

        child: Box({
            class_name,

            children: [
                icon,
                hoverRevLabel,
            ],
        }),
    });

    return widget;
};

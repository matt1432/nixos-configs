import { Box, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';
import CursorBox from '../../misc/cursorbox.js';


export default ({
    class_name,
    icon,
    label,
    spacing = 5,
}) => {
    const hoverRevLabel = Revealer({
        transition: 'slide_right',

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

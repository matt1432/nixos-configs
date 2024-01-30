const { Box, Revealer } = Widget;

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

import { Box, EventBox, Icon, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Brightness from '../../../services/brightness.js';
import Separator from '../../misc/separator.js';

const SPACING = 5;


export default () => {
    const icon = Icon({
        // @ts-expect-error
        icon: Brightness.bind('screenIcon'),
    });

    const hoverRevLabel = Revealer({
        transition: 'slide_right',

        child: Box({

            children: [
                Separator(SPACING),

                Label().hook(Brightness, (self) => {
                    self.label = `${Math.round(Brightness.screen * 100)}%`;
                }, 'screen'),
            ],
        }),
    });

    const widget = EventBox({
        on_hover: () => {
            hoverRevLabel.reveal_child = true;
        },
        on_hover_lost: () => {
            hoverRevLabel.reveal_child = false;
        },

        child: Box({
            class_name: 'brightness',

            children: [
                icon,
                hoverRevLabel,
            ],
        }),
    });

    return widget;
};

import { Box, EventBox, Icon, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Brightness from '../../../services/brightness.js';
import Separator from '../../misc/separator.js';

const SPACING = 5;


const Indicator = (props) => Icon({
    ...props,
    binds: [['icon', Brightness, 'screen-icon']],
});

const BrightnessPercentLabel = (props) => Label({
    ...props,
    connections: [[Brightness, (self) => {
        self.label = `${Math.round(Brightness.screen * 100)}%`;
    }, 'screen']],
});

export default () => {
    const rev = Revealer({
        transition: 'slide_right',
        child: Box({
            children: [
                Separator(SPACING),
                BrightnessPercentLabel(),
            ],
        }),
    });

    const widget = EventBox({
        onHover: () => {
            rev.revealChild = true;
        },
        onHoverLost: () => {
            rev.revealChild = false;
        },
        child: Box({
            className: 'brightness',
            children: [
                Indicator(),
                rev,
            ],
        }),
    });

    widget.rev = rev;

    return widget;
};

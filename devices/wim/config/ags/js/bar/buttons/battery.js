import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';

import { Box, EventBox, Icon, Label, Overlay, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const LOW_BATT = 20;


const NumOverlay = () => Label({
    className: 'bg-text',
    hpack: 'center',
    vpack: 'center',
    connections: [[Battery, (self) => {
        self.label = `${Math.floor(Battery.percent / 10)}`;
        self.visible = !Battery.charging;
    }]],
});

const Indicator = (overlay) => Overlay({
    child: Icon({
        className: 'battery-indicator',

        binds: [['icon', Battery, 'icon-name']],

        connections: [[Battery, (self) => {
            self.toggleClassName('charging', Battery.charging);
            self.toggleClassName('charged', Battery.charged);
            self.toggleClassName('low', Battery.percent < LOW_BATT);
        }]],
    }),
    overlays: [overlay],
});

const LevelLabel = (props) => Label({
    ...props,
    className: 'label',

    connections: [[Battery, (self) => {
        self.label = `${Battery.percent}%`;
    }]],
});

const SPACING = 5;

export default () => {
    const rev1 = NumOverlay();
    const rev = Revealer({
        transition: 'slide_right',
        child: Box({
            children: [
                Separator(SPACING),
                LevelLabel(),
            ],
        }),
    });

    const widget = EventBox({
        onHover: () => {
            rev.revealChild = true;

            if (!Battery.charging) {
                rev1.visible = false;
            }
        },
        onHoverLost: () => {
            rev.revealChild = false;

            if (!Battery.charging) {
                rev1.visible = true;
            }
        },
        child: Box({
            className: 'battery',
            children: [
                Indicator(rev1),

                rev,
            ],
        }),
    });

    widget.rev = rev;

    return widget;
};

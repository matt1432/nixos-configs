import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';

import { Label, Box, EventBox, Icon, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';


const Indicator = (props) => Icon({
    ...props,
    connections: [[Bluetooth, (self) => {
        if (Bluetooth.enabled) {
            self.icon = Bluetooth.connectedDevices[0] ?
                Bluetooth.connectedDevices[0].iconName :
                'bluetooth-active-symbolic';
        }
        else {
            self.icon = 'bluetooth-disabled-symbolic';
        }
    }]],
});

const ConnectedLabel = (props) => Label({
    ...props,
    connections: [[Bluetooth, (self) => {
        self.label = Bluetooth.connectedDevices[0] ?
            `${Bluetooth.connectedDevices[0]}` :
            'Disconnected';
    }, 'notify::connected-devices']],
});

const SPACING = 5;

export default () => {
    const rev = Revealer({
        transition: 'slide_right',
        child: Box({
            children: [
                Separator(SPACING),
                ConnectedLabel(),
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
            className: 'bluetooth',
            children: [
                Indicator(),

                rev,
            ],
        }),
    });

    widget.rev = rev;

    return widget;
};

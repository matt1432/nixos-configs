// @ts-expect-error
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';

import { Label, Box, EventBox, Icon, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const SPACING = 5;


export default () => {
    const icon = Icon().hook(Bluetooth, (self) => {
        if (Bluetooth.enabled) {
            self.icon = Bluetooth.connectedDevices[0] ?
                Bluetooth.connectedDevices[0].iconName :
                'bluetooth-active-symbolic';
        }
        else {
            self.icon = 'bluetooth-disabled-symbolic';
        }
    });

    const hoverRevLabel = Revealer({
        transition: 'slide_right',

        child: Box({

            children: [
                Separator(SPACING),

                Label().hook(Bluetooth, (self) => {
                    self.label = Bluetooth.connectedDevices[0] ?
                        `${Bluetooth.connectedDevices[0]}` :
                        'Disconnected';
                }, 'notify::connected-devices'),
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
            class_name: 'bluetooth',

            children: [
                icon,
                hoverRevLabel,
            ],
        }),
    });

    return widget;
};

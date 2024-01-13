import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';

import { Label, Icon } from 'resource:///com/github/Aylur/ags/widget.js';

import HoverRevealer from './hover-revealer.js';


export default () => HoverRevealer({
    class_name: 'bluetooth',

    icon: Icon().hook(Bluetooth, (self) => {
        if (Bluetooth.enabled) {
            self.icon = Bluetooth.connected_devices[0] ?
                Bluetooth.connected_devices[0].icon_name :
                'bluetooth-active-symbolic';
        }
        else {
            self.icon = 'bluetooth-disabled-symbolic';
        }
    }),

    label: Label().hook(Bluetooth, (self) => {
        self.label = Bluetooth.connected_devices[0] ?
            `${Bluetooth.connected_devices[0]}` :
            'Disconnected';
    }, 'notify::connected-devices'),
});

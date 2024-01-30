const Bluetooth = await Service.import('bluetooth');
const { Label, Icon } = Widget;

import HoverRevealer from './hover-revealer.ts';


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

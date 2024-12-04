import { bind } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalBluetooth from 'gi://AstalBluetooth';

import { ToggleButton } from '../misc/subclasses';
import Separator from '../misc/separator';

import DeviceWidget from './device';


export default () => {
    const bluetooth = AstalBluetooth.get_default();

    return (
        <box
            className="bluetooth widget"
            vertical
        >
            <centerbox homogeneous>
                <switch
                    cursor="pointer"
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.START}

                    active={bind(bluetooth, 'isPowered')}

                    setup={(self) => {
                        self.connect('notify::active', () => {
                            bluetooth.adapter?.set_powered(self.active);
                        });
                    }}
                />

                <box />

                <ToggleButton
                    cursor="pointer"
                    halign={Gtk.Align.END}

                    className="toggle-button"

                    sensitive={bind(bluetooth, 'isPowered')}

                    onToggled={(self) => {
                        self.toggleClassName('active', self.active);

                        if (self.active) {
                            bluetooth.adapter?.start_discovery();
                        }
                        else {
                            bluetooth.adapter?.stop_discovery();
                        }
                    }}
                >
                    <icon icon="emblem-synchronizing-symbolic" css="font-size: 20px;" />
                </ToggleButton>
            </centerbox>

            <Separator size={8} vertical />

            {bind(bluetooth, 'devices').as((devices) => devices
                .filter((dev) => dev.name)
                .map((dev) => DeviceWidget(dev)))}
        </box>
    );
};

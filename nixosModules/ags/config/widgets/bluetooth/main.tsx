import { bind } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalBluetooth from 'gi://AstalBluetooth';

import { ToggleButton } from '../misc/subclasses';
import Separator from '../misc/separator';

import DeviceWidget from './device';


export default () => {
    const bluetooth = AstalBluetooth.get_default();

    const deviceList = (
        <scrollable
            className="list"

            css="min-height: 200px;"
            hscroll={Gtk.PolicyType.NEVER}
            vscroll={Gtk.PolicyType.AUTOMATIC}
        >
            <box
                vertical
                setup={(self) => {
                    self.children = bluetooth.devices
                        .filter((dev) => dev.name)
                        .map((dev) => <DeviceWidget dev={dev} />);

                    self.hook(bluetooth, 'device-added', (_, dev) => {
                        if (dev.name) {
                            self.add(<DeviceWidget dev={dev} />);
                        }
                    });

                    self.hook(bluetooth, 'device-removed', (_, dev) => {
                        const children = self.children as DeviceWidget[];
                        const devWidget = children.find((ch) => ch.dev === dev);

                        if (devWidget) {
                            devWidget.revealChild = false;

                            setTimeout(() => {
                                devWidget.destroy();
                            }, devWidget.transitionDuration + 100);
                        }
                    });
                }}
            >
            </box>
        </scrollable>
    );

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
                    <icon icon="emblem-synchronizing-symbolic" css="font-size: 30px;" />
                </ToggleButton>
            </centerbox>

            <Separator size={8} vertical />

            {deviceList}
        </box>
    );
};

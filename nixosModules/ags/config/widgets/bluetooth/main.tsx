import { bind } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalBluetooth from 'gi://AstalBluetooth';

import { ListBox, ToggleButton } from '../misc/subclasses';
import Separator from '../misc/separator';

import DeviceWidget from './device';


const calculateDevSort = (dev: AstalBluetooth.Device) => {
    let value = 0;

    if (dev.connected) {
        value += 1000;
    }
    if (dev.paired) {
        value += 100;
    }
    if (dev.blocked) {
        value += 10;
    }
    if (dev.icon) {
        if (dev.icon === 'audio-headset') {
            value += 9;
        }
        if (dev.icon === 'audio-headphones') {
            value += 8;
        }
        if (dev.icon === 'audio-card') {
            value += 7;
        }
        if (dev.icon === 'computer') {
            value += 6;
        }
        if (dev.icon === 'phone') {
            value += 5;
        }
    }

    return value;
};

export default () => {
    const bluetooth = AstalBluetooth.get_default();

    const deviceList = (
        <scrollable
            className="list"

            css="min-height: 300px;"
            hscroll={Gtk.PolicyType.NEVER}
            vscroll={Gtk.PolicyType.AUTOMATIC}
        >
            <ListBox
                selectionMode={Gtk.SelectionMode.SINGLE}

                setup={(self) => {
                    bluetooth.devices
                        .filter((dev) => dev.name)
                        .forEach((dev) => {
                            self.add(<DeviceWidget dev={dev} />);
                        });

                    self.hook(bluetooth, 'device-added', (_, dev) => {
                        if (dev.name) {
                            self.add(<DeviceWidget dev={dev} />);
                            self.invalidate_sort();
                        }
                    });

                    self.hook(bluetooth, 'device-removed', (_, dev) => {
                        const children = self
                            .get_children()
                            .map((ch) => ch.get_child()) as DeviceWidget[];

                        const devWidget = children.find((ch) => ch.dev === dev);

                        if (devWidget) {
                            devWidget.revealChild = false;

                            setTimeout(() => {
                                devWidget.get_parent()?.destroy();
                            }, devWidget.transitionDuration + 100);
                        }
                    });

                    self.set_sort_func((a, b) => {
                        const devA = (a.get_child() as DeviceWidget).dev;
                        const devB = (b.get_child() as DeviceWidget).dev;

                        const sort = calculateDevSort(devB) - calculateDevSort(devA);

                        return sort !== 0 ? sort : devA.name.localeCompare(devB.name);
                    });
                }}
            />
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

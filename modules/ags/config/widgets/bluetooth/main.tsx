/* eslint-disable no-magic-numbers */

import { bind } from 'astal';
import { Gtk } from 'astal/gtk3';
import AstalBluetooth from 'gi://AstalBluetooth';

import Separator from '../misc/separator';
import { ListBox, ToggleButton } from '../misc/subclasses';
import DeviceWidget from './device';

const calculateDevSort = (dev: AstalBluetooth.Device) => {
    let value = 0;

    if (dev.get_connected()) {
        value += 1000;
    }
    if (dev.get_paired()) {
        value += 100;
    }
    if (dev.get_blocked()) {
        value += 10;
    }
    if (dev.get_icon()) {
        if (dev.get_icon() === 'audio-headset') {
            value += 9;
        }
        if (dev.get_icon() === 'audio-headphones') {
            value += 8;
        }
        if (dev.get_icon() === 'audio-card') {
            value += 7;
        }
        if (dev.get_icon() === 'computer') {
            value += 6;
        }
        if (dev.get_icon() === 'phone') {
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
                        .filter((dev) => dev.get_name())
                        .forEach((dev) => {
                            self.add(<DeviceWidget dev={dev} />);
                        });

                    self.hook(bluetooth, 'device-added', (_, dev) => {
                        if (dev.get_name()) {
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
                            devWidget.set_reveal_child(false);

                            setTimeout(() => {
                                devWidget.get_parent()?.destroy();
                            }, devWidget.get_transition_duration() + 100);
                        }
                    });

                    self.set_sort_func((a, b) => {
                        const devA = (a.get_child() as DeviceWidget).dev;
                        const devB = (b.get_child() as DeviceWidget).dev;

                        const sort =
                            calculateDevSort(devB) - calculateDevSort(devA);

                        return sort !== 0
                            ? sort
                            : devA.get_name().localeCompare(devB.get_name());
                    });
                }}
            />
        </scrollable>
    );

    return (
        <box className="bluetooth widget" vertical>
            <centerbox homogeneous>
                <switch
                    cursor="pointer"
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.START}
                    active={bind(bluetooth, 'isPowered')}
                    setup={(self) => {
                        self.connect('notify::active', () => {
                            bluetooth.get_adapter()?.set_powered(self.active);
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
                            bluetooth.get_adapter()?.start_discovery();
                        }
                        else {
                            bluetooth.get_adapter()?.stop_discovery();
                        }
                    }}
                >
                    <icon
                        icon="emblem-synchronizing-symbolic"
                        css="font-size: 30px;"
                    />
                </ToggleButton>
            </centerbox>

            <Separator size={8} vertical />

            {deviceList}
        </box>
    );
};

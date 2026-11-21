/* eslint-disable no-magic-numbers */

import { createBinding } from 'ags';
import { Gtk } from 'ags/gtk4';
import AstalBluetooth from 'gi://AstalBluetooth';
import Gio from 'gi://Gio';

import { pointer, toggleClassName } from '../../lib/widgets';
import Separator from '../misc/separator';
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

// Properties that affect sorting or filtering
const WATCHED_PROPS = ['connected', 'paired', 'blocked', 'icon', 'name'];

const DeviceList = () => {
    const bluetooth = AstalBluetooth.get_default();

    const store = new Gio.ListStore({
        item_type: AstalBluetooth.Device.$gtype,
    });

    const widgets = new Map<AstalBluetooth.Device, DeviceWidget>();
    const devSignals = new Map<AstalBluetooth.Device, number[]>();

    const filter = Gtk.CustomFilter.new((obj) =>
        Boolean((obj as unknown as AstalBluetooth.Device).get_name()),
    );

    const sorter = Gtk.CustomSorter.new((obj1, obj2) => {
        const devA = obj1 as unknown as AstalBluetooth.Device;
        const devB = obj2 as unknown as AstalBluetooth.Device;

        const sort = calculateDevSort(devB) - calculateDevSort(devA);

        return Math.sign(
            sort !== 0
                ? sort
                : (devA.get_name() ?? '').localeCompare(devB.get_name() ?? ''),
        ) as Gtk.Ordering;
    });

    const addDevice = (dev: AstalBluetooth.Device) => {
        devSignals.set(
            dev,
            WATCHED_PROPS.map((prop) =>
                dev.connect(`notify::${prop}`, () => {
                    filter.changed(Gtk.FilterChange.DIFFERENT);
                    sorter.changed(Gtk.SorterChange.DIFFERENT);
                }),
            ),
        );
        store.append(dev);
    };

    const removeDevice = (dev: AstalBluetooth.Device) => {
        devSignals.get(dev)?.forEach((id) => dev.disconnect(id));
        devSignals.delete(dev);

        const [found, position] = store.find(dev);

        if (found) {
            store.remove(position);
        }

        widgets.get(dev)?.dispose?.();
        widgets.delete(dev);
    };

    bluetooth.get_devices().forEach(addDevice);

    bluetooth.connect('device-added', (_, dev) => {
        addDevice(dev);
    });

    bluetooth.connect('device-removed', (_, dev) => {
        const devWidget = widgets.get(dev);

        if (devWidget && devWidget.get_mapped()) {
            devWidget.set_reveal_child(false);

            setTimeout(() => {
                removeDevice(dev);
            }, devWidget.get_transition_duration() + 100);
        }
        else {
            removeDevice(dev);
        }
    });

    const factory = new Gtk.SignalListItemFactory();

    factory.connect('bind', (_, listItem) => {
        const item = listItem as Gtk.ListItem;
        const dev = item.get_item() as AstalBluetooth.Device;
        let widget = widgets.get(dev);

        if (!widget) {
            widget = new DeviceWidget({ dev });
            widgets.set(dev, widget);
        }

        item.set_child(widget);
    });

    factory.connect('unbind', (_, listItem) => {
        (listItem as Gtk.ListItem).set_child(null);
    });

    return (
        <Gtk.ListView
            model={
                new Gtk.NoSelection({
                    model: new Gtk.FilterListModel({
                        model: new Gtk.SortListModel({ model: store, sorter }),
                        filter,
                    }),
                })
            }
            factory={factory}
        />
    );
};

export default () => {
    const bluetooth = AstalBluetooth.get_default();

    return (
        <box class="bluetooth widget" orientation={Gtk.Orientation.VERTICAL}>
            <centerbox>
                <switch
                    $type="start"
                    cursor={pointer}
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.START}
                    active={createBinding(bluetooth, 'isPowered')}
                    onNotifyActive={(self) => {
                        if (self.active !== bluetooth.get_is_powered()) {
                            bluetooth.get_adapter()?.set_powered(self.active);
                        }
                    }}
                />

                <box $type="center" />

                <togglebutton
                    $type="end"
                    cursor={pointer}
                    halign={Gtk.Align.END}
                    class="toggle-button"
                    sensitive={createBinding(bluetooth, 'isPowered')}
                    onToggled={(self) => {
                        toggleClassName(self, 'active', self.active);

                        if (self.active) {
                            bluetooth.get_adapter()?.start_discovery();
                        }
                        else {
                            bluetooth.get_adapter()?.stop_discovery();
                        }
                    }}
                >
                    <image
                        iconName="emblem-synchronizing-symbolic"
                        pixelSize={30}
                    />
                </togglebutton>
            </centerbox>

            <Separator size={8} vertical />

            <scrolledwindow
                class="list"
                css="min-height: 300px;"
                hscrollbarPolicy={Gtk.PolicyType.NEVER}
                vscrollbarPolicy={Gtk.PolicyType.AUTOMATIC}
            >
                <DeviceList />
            </scrolledwindow>
        </box>
    );
};

import { createBinding, createState, onCleanup } from 'ags';
import { Gtk } from 'ags/gtk4';
import AstalNetwork from 'gi://AstalNetwork';
import Gio from 'gi://Gio';

import { pointer, toggleClassName } from '../../lib/widgets';
import Separator from '../misc/separator';
import AccessPointWidget, { ApGroup } from './access-point';

const AccessPointList = () => {
    const store = new Gio.ListStore({ item_type: ApGroup.$gtype });
    const widgets = new Map<ApGroup, AccessPointWidget>();

    const sorter = Gtk.CustomSorter.new((obj1, obj2) => {
        const groupA = obj1 as unknown as ApGroup;
        const groupB = obj2 as unknown as ApGroup;

        const sort = groupB.strength - groupA.strength;

        return Math.sign(
            sort !== 0 ? sort : groupA.ssid.localeCompare(groupB.ssid),
        ) as Gtk.Ordering;
    });

    const getGroups = () => {
        const groups: ApGroup[] = [];

        for (let i = 0; i < store.get_n_items(); i++) {
            groups.push(store.get_item(i) as ApGroup);
        }

        return groups;
    };

    const update = (accessPoints: AstalNetwork.AccessPoint[]) => {
        const joined = new Map<string, AstalNetwork.AccessPoint[]>();

        accessPoints
            .filter((ap) => ap.get_ssid())
            .forEach((ap) => {
                const arr = joined.get(ap.get_ssid()!);

                if (arr) {
                    arr.push(ap);
                }
                else {
                    joined.set(ap.get_ssid()!, [ap]);
                }
            });

        const groups = getGroups();

        // Update or remove existing groups
        for (let i = groups.length - 1; i >= 0; i--) {
            const group = groups[i];
            const aps = joined.get(group.ssid);

            if (aps) {
                group.setAps(aps);
                joined.delete(group.ssid);
            }
            else {
                store.remove(i);
                widgets.get(group)?.dispose?.();
                widgets.delete(group);
            }
        }

        // Add new groups
        joined.forEach((aps, ssid) => {
            store.append(new ApGroup(ssid, aps));
        });

        sorter.changed(Gtk.SorterChange.DIFFERENT);
    };

    const factory = new Gtk.SignalListItemFactory();

    factory.connect('bind', (_, listItem) => {
        const item = listItem as Gtk.ListItem;
        const group = item.get_item() as ApGroup;
        let widget = widgets.get(group);

        if (!widget) {
            widget = new AccessPointWidget({ group });
            widgets.set(group, widget);
        }

        item.set_child(widget);
    });

    factory.connect('unbind', (_, listItem) => {
        (listItem as Gtk.ListItem).set_child(null);
    });

    const listView = (
        <Gtk.ListView
            model={
                new Gtk.NoSelection({
                    model: new Gtk.SortListModel({ model: store, sorter }),
                })
            }
            factory={factory}
        />
    ) as Gtk.ListView;

    return { listView, update };
};

export default () => {
    const wifi = AstalNetwork.get_default().get_wifi();

    if (!wifi) {
        throw new Error('Could not find wifi device.');
    }

    const { listView, update } = AccessPointList();

    const [id, setId] = createState<number | null>(null);
    const [isRefreshing, setIsRefreshing] = createState(false);

    update(wifi.get_access_points());

    isRefreshing.subscribe(() => {
        const _id = id();
        if (_id !== null) {
            wifi.disconnect(_id);
            setId(null);
        }

        if (isRefreshing()) {
            update(wifi.get_access_points());

            setId(
                wifi.connect('notify::access-points', () => {
                    update(wifi.get_access_points());
                }),
            );

            wifi.scan();
        }
    });

    onCleanup(() => {
        const _id = id();
        if (_id !== null) {
            wifi.disconnect(_id);
        }
    });

    return (
        <box class="network widget" orientation={Gtk.Orientation.VERTICAL}>
            <centerbox>
                <switch
                    $type="start"
                    cursor={pointer}
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.START}
                    active={createBinding(wifi, 'enabled')}
                    onNotifyActive={(self) => {
                        if (self.active !== wifi.get_enabled()) {
                            wifi.set_enabled(self.active);
                        }
                    }}
                />

                <box $type="center" />

                <togglebutton
                    $type="end"
                    cursor={pointer}
                    halign={Gtk.Align.END}
                    class="toggle-button"
                    sensitive={createBinding(wifi, 'enabled')}
                    active={isRefreshing}
                    onToggled={(self) => {
                        toggleClassName(self, 'active', self.active);
                        setIsRefreshing(self.active);
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
                {listView}
            </scrolledwindow>
        </box>
    );
};

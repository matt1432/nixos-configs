const Bluetooth = await Service.import('bluetooth');

const { Box, Icon, Label, ListBox, Overlay, Revealer, Scrollable } = Widget;

import CursorBox from '../misc/cursorbox.ts';

const SCROLL_THRESH_H = 200;
const SCROLL_THRESH_N = 7;

// Types
import { ListBoxRow } from 'types/@girs/gtk-3.0/gtk-3.0.cjs';
import { BluetoothDevice as BTDev } from 'types/service/bluetooth.ts';
import { DeviceBox, ScrollableGeneric } from 'global-types';


const BluetoothDevice = (dev: BTDev) => Box({
    class_name: 'menu-item',

    attribute: { dev },

    children: [Revealer({
        reveal_child: true,
        transition: 'slide_down',

        child: CursorBox({
            on_primary_click_release: () => dev.setConnection(true),

            child: Box({
                hexpand: true,

                children: [
                    Icon({
                        icon: dev.bind('icon_name'),
                    }),

                    Label({
                        label: dev.bind('name'),
                    }),

                    Icon({
                        icon: 'object-select-symbolic',
                        hexpand: true,
                        hpack: 'end',

                    }).hook(dev, (self) => {
                        self.setCss(`opacity: ${dev.paired ?
                            '1' :
                            '0'};
                        `);
                    }),
                ],
            }),
        }),
    })],
});

export const BluetoothMenu = () => {
    const DevList = new Map();

    const topArrow = Revealer({
        transition: 'slide_down',

        child: Icon({
            icon: 'down-large-symbolic',
            class_name: 'scrolled-indicator',
            size: 16,
            css: '-gtk-icon-transform: rotate(180deg);',
        }),
    });

    const bottomArrow = Revealer({
        transition: 'slide_up',

        child: Icon({
            icon: 'down-large-symbolic',
            class_name: 'scrolled-indicator',
            size: 16,
        }),
    });

    return Overlay({
        pass_through: true,

        overlays: [
            Box({
                vpack: 'start',
                hpack: 'center',
                css: 'margin-top: 12px',
                children: [topArrow],
            }),

            Box({
                vpack: 'end',
                hpack: 'center',
                css: 'margin-bottom: 12px',
                children: [bottomArrow],
            }),
        ],

        child: Box({
            class_name: 'menu',

            child: Scrollable({
                hscroll: 'never',
                vscroll: 'never',

                setup: (self) => {
                    self.on('edge-reached', (_, pos) => {
                        // Manage scroll indicators
                        if (pos === 2) {
                            topArrow.reveal_child = false;
                            bottomArrow.reveal_child = true;
                        }
                        else if (pos === 3) {
                            topArrow.reveal_child = true;
                            bottomArrow.reveal_child = false;
                        }
                    });
                },

                child: ListBox({
                    setup: (self) => {
                        self.set_sort_func((a, b) => {
                            const bState = (b.get_children()[0] as DeviceBox)
                                .attribute.dev.paired;

                            const aState = (a.get_children()[0] as DeviceBox)
                                .attribute.dev.paired;

                            return bState - aState;
                        });

                        self.hook(Bluetooth, () => {
                            // Get all devices
                            const Devices = Bluetooth.devices.concat(
                                Bluetooth.connected_devices,
                            );

                            // Add missing devices
                            Devices.forEach((dev) => {
                                if (!DevList.has(dev) && dev.name) {
                                    DevList.set(dev, BluetoothDevice(dev));

                                    self.add(DevList.get(dev));
                                    self.show_all();
                                }
                            });

                            // Delete ones that don't exist anymore
                            const difference = Array.from(DevList.keys())
                                .filter((dev) => !Devices
                                    .find((d) => dev === d) &&
                                    dev.name);

                            difference.forEach((dev) => {
                                const devWidget = DevList.get(dev);

                                if (devWidget) {
                                    if (devWidget.toDestroy) {
                                        devWidget.get_parent().destroy();
                                        DevList.delete(dev);
                                    }
                                    else {
                                        devWidget.child.reveal_child = false;
                                        devWidget.toDestroy = true;
                                    }
                                }
                            });

                            // Start scrolling after a specified height
                            // is reached by the children
                            const height = Math.max(
                                self.get_parent()?.get_allocated_height() || 0,
                                SCROLL_THRESH_H,
                            );

                            const scroll = (self.get_parent() as ListBoxRow)
                                ?.get_parent() as ScrollableGeneric;

                            if (scroll) {
                                const n_child = self.get_children().length;

                                if (n_child > SCROLL_THRESH_N) {
                                    scroll.vscroll = 'always';
                                    scroll.setCss(`min-height: ${height}px;`);

                                    // Make bottom scroll indicator appear only
                                    // when first getting overflowing children
                                    if (!(bottomArrow.reveal_child === true ||
                                      topArrow.reveal_child === true)) {
                                        bottomArrow.reveal_child = true;
                                    }
                                }
                                else {
                                    scroll.vscroll = 'never';
                                    scroll.setCss('');
                                    topArrow.reveal_child = false;
                                    bottomArrow.reveal_child = false;
                                }
                            }

                            // Trigger sort_func
                            (self.get_children() as ListBoxRow[])
                                .forEach((ch) => {
                                    ch.changed();
                                });
                        });
                    },
                }),
            }),
        }),
    });
};

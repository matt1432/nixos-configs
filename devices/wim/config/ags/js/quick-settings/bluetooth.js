import App from 'resource:///com/github/Aylur/ags/app.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';

import { Box, Icon, Label, ListBox, Overlay, Revealer, Scrollable } from 'resource:///com/github/Aylur/ags/widget.js';

import CursorBox from '../misc/cursorbox.js';

const SCROLL_THRESH_H = 200;
const SCROLL_THRESH_N = 7;


const BluetoothDevice = (dev) => {
    const widget = Box({
        className: 'menu-item',
    });

    const child = Box({
        hexpand: true,
        children: [
            Icon({
                binds: [['icon', dev, 'icon-name']],
            }),

            Label({
                binds: [['label', dev, 'name']],
            }),

            Icon({
                icon: 'object-select-symbolic',
                hexpand: true,
                hpack: 'end',
                setup: (self) => {
                    self.hook(dev, () => {
                        self.setCss(`opacity: ${dev.paired ? '1' : '0'};`);
                    });
                },
            }),
        ],
    });

    widget.dev = dev;
    widget.add(Revealer({
        revealChild: true,
        transition: 'slide_down',
        child: CursorBox({
            on_primary_click_release: () => dev.setConnection(true),
            child,
        }),
    }));

    return widget;
};

export const BluetoothMenu = () => {
    const DevList = new Map();
    const topArrow = Revealer({
        transition: 'slide_down',
        child: Icon({
            icon: `${App.configDir }/icons/down-large.svg`,
            className: 'scrolled-indicator',
            size: 16,
            css: '-gtk-icon-transform: rotate(180deg);',
        }),
    });

    const bottomArrow = Revealer({
        transition: 'slide_up',
        child: Icon({
            icon: `${App.configDir }/icons/down-large.svg`,
            className: 'scrolled-indicator',
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
            className: 'menu',

            child: Scrollable({
                hscroll: 'never',
                vscroll: 'never',

                setup: (self) => {
                    self.on('edge-reached', (_, pos) => {
                        // Manage scroll indicators
                        if (pos === 2) {
                            topArrow.revealChild = false;
                            bottomArrow.revealChild = true;
                        }
                        else if (pos === 3) {
                            topArrow.revealChild = true;
                            bottomArrow.revealChild = false;
                        }
                    });
                },

                child: ListBox({
                    setup: (self) => {
                        self.set_sort_func((a, b) => {
                            return b.get_children()[0].dev.paired -
                                a.get_children()[0].dev.paired;
                        });

                        self.hook(Bluetooth, () => {
                            // Get all devices
                            const Devices = [].concat(
                                Bluetooth.devices,
                                Bluetooth.connectedDevices,
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
                                        devWidget.children[0]
                                            .revealChild = false;
                                        devWidget.toDestroy = true;
                                    }
                                }
                            });

                            // Start scrolling after a specified height
                            // is reached by the children
                            const height = Math.max(
                                self.get_parent().get_allocated_height(),
                                SCROLL_THRESH_H,
                            );

                            const scroll = self.get_parent().get_parent();

                            if (self.get_children().length > SCROLL_THRESH_N) {
                                scroll.vscroll = 'always';
                                scroll.setCss(`min-height: ${height}px;`);

                                // Make bottom scroll indicator appear only
                                // when first getting overflowing children
                                if (!(bottomArrow.revealChild === true ||
                                    topArrow.revealChild === true)) {
                                    bottomArrow.revealChild = true;
                                }
                            }
                            else {
                                scroll.vscroll = 'never';
                                scroll.setCss('');
                                topArrow.revealChild = false;
                                bottomArrow.revealChild = false;
                            }

                            // Trigger sort_func
                            self.get_children().forEach((ch) => {
                                ch.changed();
                            });
                        });
                    },
                }),
            }),
        }),
    });
};

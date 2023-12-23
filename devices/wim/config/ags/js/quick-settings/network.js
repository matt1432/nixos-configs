import App from 'resource:///com/github/Aylur/ags/app.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, Icon, Label, ListBox, Overlay, Revealer, Scrollable } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import CursorBox from '../misc/cursorbox.js';

const SCROLL_THRESH_H = 200;
const SCROLL_THRESH_N = 7;

/** @typedef {import('types/widgets/box').default} Box */


/** @param {any} ap */
const AccessPoint = (ap) => {
    const widget = Box({
        class_name: 'menu-item',
        attribute: {
            ap: Variable(ap),
        },
    });


    const child = Box({
        hexpand: true,
        children: [
            Icon().hook(widget.attribute.ap, (self) => {
                self.icon = widget.attribute.ap.value.iconName;
            }),

            Label().hook(widget.attribute.ap, (self) => {
                self.label = widget.attribute.ap.value.ssid || '';
            }),

            Icon({
                icon: 'object-select-symbolic',
                hexpand: true,
                hpack: 'end',

                setup: (self) => {
                    self.hook(Network, () => {
                        self.setCss(
                            `opacity: ${
                                widget.attribute.ap.value.ssid ===
                                    Network.wifi.ssid ?
                                    '1' :
                                    '0'
                            };
                        `,
                        );
                    });
                },
            }),
        ],
    });

    widget.add(Revealer({
        reveal_child: true,
        transition: 'slide_down',

        child: CursorBox({
            on_primary_click_release: () => {
                execAsync(`nmcli device wifi connect
                    ${widget.attribute.ap.value.bssid}`).catch(print);
            },
            child,
        }),
    }));

    return widget;
};

export const NetworkMenu = () => {
    const APList = new Map();

    const topArrow = Revealer({
        transition: 'slide_down',

        child: Icon({
            icon: `${App.configDir }/icons/down-large.svg`,
            class_name: 'scrolled-indicator',
            size: 16,
            css: '-gtk-icon-transform: rotate(180deg);',
        }),
    });

    const bottomArrow = Revealer({
        transition: 'slide_up',

        child: Icon({
            icon: `${App.configDir }/icons/down-large.svg`,
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
                        // @ts-expect-error
                        self.set_sort_func(
                            /**
                             * @param {Box} a
                             * @param {Box} b
                             */
                            (a, b) => {
                                return b.get_children()[0]
                                    // @ts-expect-error
                                    .attribute.ap.value.strength -
                                // @ts-expect-error
                                a.get_children()[0].attribute.ap.value.strength;
                            },
                        );

                        self.hook(Network, () => {
                            // Add missing APs
                            Network.wifi?.access_points.forEach((ap) => {
                                if (ap.ssid !== 'Unknown') {
                                    if (APList.has(ap.ssid)) {
                                        const accesPoint = APList.get(ap.ssid)
                                            .attribute.ap.value;

                                        if (accesPoint.strength < ap.strength) {
                                            APList.get(ap.ssid).attribute
                                                .ap.value = ap;
                                        }
                                    }
                                    else {
                                        APList.set(ap.ssid, AccessPoint(ap));

                                        // @ts-expect-error
                                        self.add(APList.get(ap.ssid));
                                        self.show_all();
                                    }
                                }
                            });

                            // Delete ones that don't exist anymore
                            const difference = Array.from(APList.keys())
                                .filter((ssid) => !Network.wifi.access_points
                                    .find((ap) => ap.ssid === ssid) &&
                                    ssid !== 'Unknown');

                            difference.forEach((ssid) => {
                                const apWidget = APList.get(ssid);

                                if (apWidget) {
                                    if (apWidget.toDestroy) {
                                        apWidget.get_parent().destroy();
                                        APList.delete(ssid);
                                    }
                                    else {
                                        apWidget.children[0]
                                            .reveal_child = false;
                                        apWidget.toDestroy = true;
                                    }
                                }
                            });

                            // Start scrolling after a specified height
                            // is reached by the children
                            const height = Math.max(
                                self.get_parent()?.get_allocated_height() || 0,
                                SCROLL_THRESH_H,
                            );

                            const scroll = self.get_parent()?.get_parent();

                            if (scroll) {
                                // @ts-expect-error
                                const n_child = self.get_children().length;

                                if (n_child > SCROLL_THRESH_N) {
                                    // @ts-expect-error
                                    scroll.vscroll = 'always';
                                    // @ts-expect-error
                                    scroll.setCss(`min-height: ${height}px;`);

                                    // Make bottom scroll indicator appear only
                                    // when first getting overflowing children
                                    if (!(bottomArrow.reveal_child === true ||
                                        topArrow.reveal_child === true)) {
                                        bottomArrow.reveal_child = true;
                                    }
                                }
                                else {
                                    // @ts-expect-error
                                    scroll.vscroll = 'never';
                                    // @ts-expect-error
                                    scroll.setCss('');
                                    topArrow.reveal_child = false;
                                    bottomArrow.reveal_child = false;
                                }
                            }

                            // Trigger sort_func
                            // @ts-expect-error
                            self.get_children().forEach(
                                /** @param {Box} ListBoxRow */
                                (ListBoxRow) => {
                                    // @ts-expect-error
                                    ListBoxRow.changed();
                                },
                            );
                        });
                    },
                }),
            }),
        }),
    });
};

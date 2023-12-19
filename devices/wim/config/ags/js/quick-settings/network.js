import App from 'resource:///com/github/Aylur/ags/app.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, Icon, Label, ListBox, Overlay, Revealer, Scrollable } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import CursorBox from '../misc/cursorbox.js';

const SCROLL_THRESH_H = 200;
const SCROLL_THRESH_N = 7;


const AccessPoint = (ap) => {
    const widget = Box({
        className: 'menu-item',
    });

    widget.ap = Variable(ap);

    const child = Box({
        hexpand: true,
        children: [
            Icon({
                setup: (self) => {
                    self.hook(widget.ap, () => {
                        self.icon = widget.ap.value.iconName;
                    });
                },
            }),

            Label({
                setup: (self) => {
                    self.hook(widget.ap, () => {
                        self.label = widget.ap.value.ssid || '';
                    });
                },
            }),

            Icon({
                icon: 'object-select-symbolic',
                hexpand: true,
                hpack: 'end',
                setup: (self) => {
                    self.hook(Network, () => {
                        self.setCss(
                            `opacity: ${
                                widget.ap.value.ssid === Network.wifi.ssid ?
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
        revealChild: true,
        transition: 'slide_down',
        child: CursorBox({
            on_primary_click_release: () => {
                execAsync(`nmcli device wifi connect
                    ${widget.ap.value.bssid}`).catch(print);
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
                            return b.get_children()[0].ap.value.strength -
                                a.get_children()[0].ap.value.strength;
                        });

                        self.hook(Network, () => {
                            // Add missing APs
                            Network.wifi?.access_points.forEach((ap) => {
                                if (ap.ssid !== 'Unknown') {
                                    if (APList.has(ap.ssid)) {
                                        const accesPoint = APList.get(ap.ssid)
                                            .ap.value;

                                        if (accesPoint.strength < ap.strength) {
                                            APList.get(ap.ssid).ap.value = ap;
                                        }
                                    }
                                    else {
                                        APList.set(ap.ssid, AccessPoint(ap));

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
                                            .revealChild = false;
                                        apWidget.toDestroy = true;
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

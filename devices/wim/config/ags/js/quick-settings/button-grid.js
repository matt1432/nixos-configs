import App from 'resource:///com/github/Aylur/ags/app.js';
// @ts-expect-error
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, Icon, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import { SpeakerIcon, MicIcon } from '../misc/audio-icons.js';
import CursorBox from '../misc/cursorbox.js';
import Separator from '../misc/separator.js';

import { NetworkMenu } from './network.js';
import { BluetoothMenu } from './bluetooth.js';

const SPACING = 28;
const ButtonStates = [];

/** @typedef {import('types/widgets/widget').default} Widget */


/**
 * @param {{
 *      command?: function
 *      secondary_command?: function
 *      onOpen?: function(Widget):void
 *      icon: any
 *      indicator?: any
 *      menu?: any
 * }} o
 */
const GridButton = ({
    command = () => {/**/},
    secondary_command = () => {/**/},
    onOpen = () => {/**/},
    icon,
    indicator,
    menu,
}) => {
    const Activated = Variable(false);

    ButtonStates.push(Activated);

    // Allow setting icon dynamically or statically
    if (typeof icon === 'string') {
        icon = Icon({
            class_name: 'grid-label',
            icon,
            setup: (self) => {
                self.hook(Activated, () => {
                    self.setCss(`color: ${Activated.value ?
                        'rgba(189, 147, 249, 0.8)' :
                        'unset'};`);
                });
            },
        });
    }
    else {
        icon = Icon({
            class_name: 'grid-label',
            setup: (self) => {
                self
                    .hook(...icon)
                    .hook(Activated, () => {
                        self.setCss(`color: ${Activated.value ?
                            'rgba(189, 147, 249, 0.8)' :
                            'unset'};`);
                    });
            },
        });
    }

    if (indicator) {
        indicator = Label({
            class_name: 'sub-label',
            justification: 'left',
            truncate: 'end',
            maxWidthChars: 12,
            setup: (self) => {
                self.hook(...indicator);
            },
        });
    }

    if (menu) {
        menu = Revealer({
            transition: 'slide_down',
            child: menu,
            binds: [['revealChild', Activated, 'value']],
        });
    }

    const widget = Box({
        vertical: true,
        children: [
            Box({
                class_name: 'grid-button',
                children: [

                    CursorBox({
                        class_name: 'left-part',

                        on_primary_click_release: () => {
                            if (Activated.value) {
                                secondary_command();
                            }
                            else {
                                command();
                            }
                        },

                        child: icon,
                    }),

                    CursorBox({
                        class_name: 'right-part',

                        on_primary_click_release: () => {
                            ButtonStates.forEach((state) => {
                                if (state !== Activated) {
                                    state.value = false;
                                }
                            });
                            Activated.value = !Activated.value;
                        },

                        on_hover: (self) => {
                            if (menu) {
                                const rowMenu =
                                    self.get_parent()
                                        ?.get_parent()?.get_parent()
                                        ?.get_parent()?.get_parent()
                                        ?.children[1];

                                const isSetup = rowMenu.get_children()
                                    .find((ch) => ch === menu);

                                if (!isSetup) {
                                    rowMenu.add(menu);
                                    rowMenu.show_all();
                                }
                            }
                        },

                        child: Icon({
                            icon: `${App.configDir }/icons/down-large.svg`,
                            class_name: 'grid-chev',

                            setup: (self) => {
                                self.hook(Activated, () => {
                                    let deg = 270;

                                    if (Activated.value) {
                                        deg = menu ? 360 : 450;
                                        onOpen(menu);
                                    }
                                    self.setCss(`
                                        -gtk-icon-transform: rotate(${deg}deg);
                                    `);
                                });
                            },
                        }),
                    }),

                ],
            }),
            indicator,
        ],
    });

    return widget;
};

const Row = ({ buttons } = {}) => {
    const widget = Box({
        vertical: true,

        children: [
            Box({
                class_name: 'button-row',
                hpack: 'center',
            }),

            Box({ vertical: true }),
        ],
    });

    for (let i = 0; i < buttons.length; ++i) {
        if (i === buttons.length - 1) {
            widget.children[0].add(buttons[i]);
        }
        else {
            widget.children[0].add(buttons[i]);
            widget.children[0].add(Separator(SPACING));
        }
    }

    return widget;
};

const FirstRow = () => Row({
    buttons: [

        GridButton({
            command: () => Network.toggleWifi(),

            secondary_command: () => {
                // TODO: connection editor
            },

            icon: [Network, (icon) => {
                icon.icon = Network.wifi?.iconName;
            }],

            indicator: [Network, (self) => {
                self.label = Network.wifi?.ssid || Network.wired?.internet;
            }],

            menu: NetworkMenu(),
            onOpen: () => Network.wifi.scan(),
        }),

        // TODO: do vpn
        GridButton({
            command: () => {
                //
            },

            secondary_command: () => {
                //
            },

            icon: 'airplane-mode-disabled-symbolic',
        }),

        GridButton({
            command: () => Bluetooth.toggle(),

            secondary_command: () => {
                // TODO: bluetooth connection editor
            },

            icon: [Bluetooth, (self) => {
                if (Bluetooth.enabled) {
                    self.icon = Bluetooth.connectedDevices[0] ?
                        Bluetooth.connectedDevices[0].iconName :
                        'bluetooth-active-symbolic';
                }
                else {
                    self.icon = 'bluetooth-disabled-symbolic';
                }
            }],

            indicator: [Bluetooth, (self) => {
                self.label = Bluetooth.connectedDevices[0] ?
                    `${Bluetooth.connectedDevices[0]}` :
                    'Disconnected';
            }, 'notify::connected-devices'],

            menu: BluetoothMenu(),
            onOpen: (menu) => {
                execAsync(`bluetoothctl scan ${menu.revealChild ?
                    'on' :
                    'off'}`).catch(print);
            },
        }),

    ],
});

const SecondRow = () => Row({
    buttons: [
        GridButton({
            command: () => {
                execAsync(['pactl', 'set-sink-mute',
                    '@DEFAULT_SINK@', 'toggle']).catch(print);
            },

            secondary_command: () => {
                execAsync(['bash', '-c', 'pavucontrol'])
                    .catch(print);
            },

            icon: [SpeakerIcon, (self) => {
                self.icon = SpeakerIcon.value;
            }],
        }),

        GridButton({
            command: () => {
                execAsync(['pactl', 'set-source-mute',
                    '@DEFAULT_SOURCE@', 'toggle']).catch(print);
            },

            secondary_command: () => {
                execAsync(['bash', '-c', 'pavucontrol'])
                    .catch(print);
            },

            icon: [MicIcon, (self) => {
                self.icon = MicIcon.value;
            }],
        }),

        GridButton({
            command: () => {
                execAsync(['lock']).catch(print);
            },
            secondary_command: () => App.openWindow('powermenu'),
            icon: 'system-lock-screen-symbolic',
        }),
    ],
});

export default () => Box({
    class_name: 'button-grid',
    vertical: true,
    hpack: 'center',
    children: [
        FirstRow(),
        Separator(10, { vertical: true }),
        SecondRow(),
    ],
});

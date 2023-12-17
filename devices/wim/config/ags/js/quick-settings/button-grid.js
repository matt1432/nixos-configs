import App from 'resource:///com/github/Aylur/ags/app.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Variable from 'resource:///com/github/Aylur/ags/variable.js';

import { Box, Icon, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import { SpeakerIcon, MicIcon } from '../misc/audio-icons.js';
import EventBox from '../misc/cursorbox.js';
import Separator from '../misc/separator.js';

import { NetworkMenu } from './network.js';
import { BluetoothMenu } from './bluetooth.js';

const SPACING = 28;


const ButtonStates = [];
const GridButton = ({
    command = () => { /**/ },
    secondaryCommand = () => { /**/ },
    onOpen = () => { /**/ },
    icon,
    indicator,
    menu,
} = {}) => {
    const Activated = Variable(false);

    ButtonStates.push(Activated);

    // Allow setting icon dynamically or statically
    if (typeof icon === 'string') {
        icon = Icon({
            className: 'grid-label',
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
            className: 'grid-label',
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
            className: 'sub-label',
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
                className: 'grid-button',
                children: [

                    EventBox({
                        className: 'left-part',

                        onPrimaryClickRelease: () => {
                            if (Activated.value) {
                                secondaryCommand();
                            }
                            else {
                                command();
                            }
                        },

                        child: icon,
                    }),

                    EventBox({
                        className: 'right-part',

                        onPrimaryClickRelease: () => {
                            ButtonStates.forEach((state) => {
                                if (state !== Activated) {
                                    state.value = false;
                                }
                            });
                            Activated.value = !Activated.value;
                        },

                        onHover: (self) => {
                            if (menu) {
                                const rowMenu = self.get_parent().get_parent()
                                    .get_parent().get_parent().children[1];

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
                            className: 'grid-chev',

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
                className: 'button-row',
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

            secondaryCommand: () => {
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

            secondaryCommand: () => {
                //
            },

            icon: 'airplane-mode-disabled-symbolic',
        }),

        GridButton({
            command: () => Bluetooth.toggle(),

            secondaryCommand: () => {
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

            secondaryCommand: () => {
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

            secondaryCommand: () => {
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
            secondaryCommand: () => App.openWindow('powermenu'),
            icon: 'system-lock-screen-symbolic',
        }),
    ],
});

export default () => Box({
    className: 'button-grid',
    vertical: true,
    hpack: 'center',
    children: [
        FirstRow(),
        Separator(10, { vertical: true }),
        SecondRow(),
    ],
});

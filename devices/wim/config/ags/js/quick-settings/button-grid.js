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

const SPACING = 28;


const ButtonStates = [];
const GridButton = ({
    command = () => { /**/ },
    secondaryCommand = () => { /**/ },
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
            connections: [[Activated, (self) => {
                self.setCss(`color: ${Activated.value ?
                    'rgba(189, 147, 249, 0.8)' :
                    'unset'};`);
            }]],
        });
    }
    else {
        icon = Icon({
            className: 'grid-label',
            connections: [
                icon,
                [Activated, (self) => {
                    self.setCss(`color: ${Activated.value ?
                        'rgba(189, 147, 249, 0.8)' :
                        'unset'};`);
                }],
            ],
        });
    }

    if (indicator) {
        indicator = Label({
            className: 'sub-label',
            justification: 'left',
            truncate: 'end',
            maxWidthChars: 12,
            connections: [indicator],
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

                            connections: [[Activated, (self) => {
                                let deg = 270;

                                if (Activated.value) {
                                    deg = menu ? 360 : 450;
                                }
                                self.setCss(`
                                    -gtk-icon-transform: rotate(${deg}deg);
                                `);
                            }]],
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

            Box(),
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
                execAsync(['bash', '-c', 'nm-connection-editor'])
                    .catch(print);
            },

            icon: [Network, (icon) => {
                icon.icon = Network.wifi?.iconName;
            }],

            indicator: [Network, (self) => {
                self.label = Network.wifi?.ssid || Network.wired?.internet;
            }],

            menu: NetworkMenu(),
        }),

        GridButton({
            command: () => {
                execAsync(['bash', '-c', '$AGS_PATH/qs-toggles.sh blue-toggle'])
                    .catch(print);
            },

            secondaryCommand: () => {
                execAsync(['bash', '-c', 'blueberry'])
                    .catch(print);
            },

            icon: [Bluetooth, (self) => {
                if (Bluetooth.enabled) {
                    self.icon = 'bluetooth-active-symbolic';
                    execAsync(['bash', '-c',
                        'echo 󰂯 > $HOME/.config/.bluetooth']).catch(print);
                }
                else {
                    self.icon = 'bluetooth-disabled-symbolic';
                    execAsync(['bash', '-c',
                        'echo 󰂲 > $HOME/.config/.bluetooth']).catch(print);
                }
            }, 'changed'],

            indicator: [Bluetooth, (self) => {
                if (Bluetooth.connectedDevices[0]) {
                    self.label = String(Bluetooth.connectedDevices[0]);
                }
                else {
                    self.label = 'Disconnected';
                }
            }, 'changed'],
        }),

        // TODO: replace with vpn
        GridButton({
            command: () => {
                execAsync(['bash', '-c',
                    '$AGS_PATH/qs-toggles.sh toggle-radio']).catch(print);
            },

            secondaryCommand: () => {
                execAsync(['notify-send', 'set this up moron'])
                    .catch(print);
            },

            icon: [Network, (self) => {
                if (Network.wifi.enabled) {
                    self.icon = 'airplane-mode-disabled-symbolic';
                }
                else {
                    self.icon = 'airplane-mode-symbolic';
                }
            }, 'changed'],
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
                execAsync(['bash', '-c', '$LOCK_PATH/lock.sh'])
                    .catch(print);
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

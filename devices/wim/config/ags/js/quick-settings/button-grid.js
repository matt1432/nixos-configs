import App       from 'resource:///com/github/Aylur/ags/app.js';
import Audio     from 'resource:///com/github/Aylur/ags/service/audio.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import Network   from 'resource:///com/github/Aylur/ags/service/network.js';
import Variable  from 'resource:///com/github/Aylur/ags/variable.js';
import { Box, Icon, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import EventBox  from '../misc/cursorbox.js';
import Separator from '../misc/separator.js';


const ButtonStates = [];
const GridButton = ({
    command = () => {},
    secondaryCommand = () => {},
    icon,
    indicator,
    menu,
} = {}) => {
    const Activated = Variable(false);
    ButtonStates.push(Activated);

    // allow setting icon dynamically or statically
    if (typeof icon === 'string') {
        icon = Icon({
            className: 'grid-label',
            icon: icon,
            connections: [[Activated, self => {
                self.setCss(`color: ${Activated.value ? 'rgba(189, 147, 249, 0.8)' : 'unset'};`);
            }]],
        });
    }
    else {
        icon = Icon({
            className: 'grid-label',
            connections: [
                icon,
                [Activated, self => {
                    self.setCss(`color: ${Activated.value ? 'rgba(189, 147, 249, 0.8)' : 'unset'};`);
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
                            if (!Activated.value)
                                command();
                            else
                                secondaryCommand();
                        },
                        child: icon,
                    }),

                    EventBox({
                        className: 'right-part',
                        onPrimaryClickRelease: () => {
                            ButtonStates.forEach(state => {
                                if (state !== Activated)
                                    state.value = false;
                            });
                            Activated.value = !Activated.value;
                        },
                        onHover: self => {
                            if (menu) {
                                const rowMenu = self.get_parent().get_parent()
                                    .get_parent().get_parent().children[1];

                                if (!rowMenu.get_children().find(ch => ch === menu)) {
                                    rowMenu.add(menu);
                                    rowMenu.show_all();
                                }
                            }
                        },
                        child: Icon({
                            icon: App.configDir + '/icons/down-large.svg',
                            connections: [[Activated, self => {
                                let deg = 270;
                                if (Activated.value)
                                    deg = menu ? 360 : 450;
                                self.setCss(`-gtk-icon-transform: rotate(${deg}deg);`);
                            }]],
                            className: 'grid-chev',
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
        if (i !== buttons.length - 1) {
            widget.children[0].add(buttons[i]);
            widget.children[0].add(Separator(28));
        }
        else {
            widget.children[0].add(buttons[i]);
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
            icon: [Network, icon => icon.icon = Network.wifi?.iconName],
            indicator: [Network, self => self.label = Network.wifi?.ssid || Network.wired?.internet],

            menu: Box({
                className: 'menu',
                vertical: true,
                connections: [[Network, box => box.children =
                    Network.wifi?.access_points.map(ap => EventBox({
                        isButton: true,
                        on_clicked: () => execAsync(`nmcli device wifi connect ${ap.bssid}`).catch(print),
                        child: Box({
                            children: [
                                Icon(ap.iconName),
                                Label(ap.ssid || ''),
                                ap.active && Icon({
                                    icon: 'object-select-symbolic',
                                    hexpand: true,
                                    hpack: 'end',
                                }),
                            ],
                        }),
                    })),
                ]],
            }),
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
            icon: [Bluetooth, self => {
                if (Bluetooth.enabled) {
                    self.icon = 'bluetooth-active-symbolic';
                    execAsync(['bash', '-c', 'echo 󰂯 > $HOME/.config/.bluetooth'])
                        .catch(print);
                }
                else {
                    self.icon = 'bluetooth-disabled-symbolic';
                    execAsync(['bash', '-c', 'echo 󰂲 > $HOME/.config/.bluetooth'])
                        .catch(print);
                }
            }, 'changed'],
            indicator: [Bluetooth, self => {
                if (Bluetooth.connectedDevices[0])
                    self.label = String(Bluetooth.connectedDevices[0]);
                else
                    self.label = 'Disconnected';
            }, 'changed'],
        }),

        // TODO: replace with vpn
        GridButton({
            command: () => {
                execAsync(['bash', '-c', '$AGS_PATH/qs-toggles.sh toggle-radio'])
                    .catch(print);
            },
            secondaryCommand: () => {
                execAsync(['notify-send', 'set this up moron'])
                    .catch(print);
            },
            icon: [Network, self => {
                if (Network.wifi.enabled)
                    self.icon = 'airplane-mode-disabled-symbolic';
                else
                    self.icon = 'airplane-mode-symbolic';
            }, 'changed'],
        }),

    ],
});

const items = {
    101: 'audio-volume-overamplified-symbolic',
    67: 'audio-volume-high-symbolic',
    34: 'audio-volume-medium-symbolic',
    1: 'audio-volume-low-symbolic',
    0: 'audio-volume-muted-symbolic',
};

const itemsMic = {
    2: 'audio-input-microphone-high-symbolic',
    1: 'audio-input-microphone-muted-symbolic',
    0: 'audio-input-microphone-muted-symbolic',
};

const SecondRow = () => Row({
    buttons: [

        GridButton({
            command: () => {
                execAsync(['swayosd-client', '--output-volume', 'mute-toggle'])
                    .catch(print);
            },

            secondaryCommand: () => {
                execAsync(['bash', '-c', 'pavucontrol'])
                    .catch(print);
            },

            icon: [Audio, icon => {
                if (Audio.speaker) {
                    if (Audio.speaker.stream.isMuted) {
                        icon.icon = items[0];
                    }
                    else {
                        const vol = Audio.speaker.volume * 100;
                        for (const threshold of [-1, 0, 33, 66, 100]) {
                            if (vol > threshold + 1)
                                icon.icon = items[threshold + 1];
                        }
                    }
                }
            }, 'speaker-changed'],
        }),

        GridButton({
            command: () => {
                execAsync(['swayosd-client', '--input-volume', 'mute-toggle'])
                    .catch(print);
            },

            secondaryCommand: () => {
                execAsync(['bash', '-c', 'pavucontrol'])
                    .catch(print);
            },

            icon: [Audio, icon => {
                if (Audio.microphone) {
                    if (Audio.microphone.stream.isMuted) {
                        icon.icon = itemsMic[0];
                    }
                    else {
                        const vol = Audio.microphone.volume * 100;
                        for (const threshold of [-1, 0, 1]) {
                            if (vol > threshold + 1)
                                icon.icon = itemsMic[threshold + 1];
                        }
                    }
                }
            }, 'microphone-changed'],
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

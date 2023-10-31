import App       from 'resource:///com/github/Aylur/ags/app.js';
import Audio     from 'resource:///com/github/Aylur/ags/service/audio.js';
import Bluetooth from 'resource:///com/github/Aylur/ags/service/bluetooth.js';
import Network   from 'resource:///com/github/Aylur/ags/service/network.js';
import { Box, CenterBox, Label, Icon } from 'resource:///com/github/Aylur/ags/widget.js';
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

import EventBox from '../misc/cursorbox.js';


const GridButton = ({
    command = () => {},
    secondaryCommand = () => {},
    icon,
} = {}) => Box({
    className: 'grid-button',
    children: [

        EventBox({
            className: 'left-part',
            onPrimaryClickRelease: () => command(),
            child: icon,
        }),

        EventBox({
            className: 'right-part',
            onPrimaryClickRelease: () => secondaryCommand(),
            child: Label({
                label: ' ',
                className: 'grid-chev',
            }),
        }),

    ],
});

const FirstRow = () => Box({
    className: 'button-row',
    halign: 'center',
    style: 'margin-top: 15px; margin-bottom: 7px;',
    children: [

        GridButton({
            command: () => Network.toggleWifi(),
            secondaryCommand: () => {
                execAsync(['bash', '-c', 'nm-connection-editor'])
                    .catch(print);
            },
            icon: Icon({
                className: 'grid-label',
                connections: [[Network, icon => {
                    if (Network.wifi.enabled)
                        icon.icon = 'network-wireless-connected-symbolic';

                    else
                        icon.icon = 'network-wireless-offline-symbolic';
                }, 'changed']],
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
            icon: Icon({
                className: 'grid-label',
                connections: [[Bluetooth, self => {
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
                }, 'changed']],
            }),
        }),

        GridButton({
            command: () => {
                execAsync(['bash', '-c', '$AGS_PATH/qs-toggles.sh toggle-radio'])
                    .catch(print);
            },
            secondaryCommand: () => {
                execAsync(['notify-send', 'set this up moron'])
                    .catch(print);
            },
            icon: Icon({
                className: 'grid-label',
                connections: [[Network, self => {
                    if (Network.wifi.enabled)
                        self.icon = 'airplane-mode-disabled-symbolic';
                    else
                        self.icon = 'airplane-mode-symbolic';
                }, 'changed']],
            }),
        }),

    ],
});

const SubRow = () => CenterBox({
    halign: 'start',
    children: [

        Label({
            className: 'sub-label',
            truncate: 'end',
            maxWidthChars: 12,
            connections: [[Network, self => {
                // TODO: handle ethernet too
                self.label = Network.wifi.ssid;
            }, 'changed']],
        }),

        Label({
            className: 'sub-label',
            truncate: 'end',
            maxWidthChars: 12,
            connections: [[Bluetooth, self => {
                if (Bluetooth.connectedDevices[0])
                    self.label = String(Bluetooth.connectedDevices[0]);
                else
                    self.label = 'Disconnected';
            }, 'changed']],
        }),

        null,

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

const SecondRow = () => Box({
    className: 'button-row',
    halign: 'center',
    style: 'margin-top: 7px; margin-bottom: 15px;',
    children: [

        GridButton({
            command: () => {
                execAsync(['swayosd-client', '--output-volume', 'mute-toggle'])
                    .catch(print);
            },

            secondaryCommand: () => {
                execAsync(['bash', '-c', 'pavucontrol'])
                    .catch(print);
            },

            icon: Icon({
                className: 'grid-label',
                connections: [[Audio, icon => {
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
                }, 'speaker-changed']],
            }),
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

            icon: Icon({
                className: 'grid-label',
                connections: [[Audio, icon => {
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
                }, 'microphone-changed']],
            }),
        }),

        GridButton({
            command: () => {
                execAsync(['bash', '-c', '$LOCK_PATH/lock.sh'])
                    .catch(print);
            },
            secondaryCommand: () => App.openWindow('powermenu'),
            icon: Label({
                className: 'grid-label',
                label: ' 󰌾 ',
            }),
        }),

    ],
});

export default () => Box({
    className: 'button-grid',
    vertical: true,
    halign: 'center',
    children: [
        FirstRow(),
        SubRow(),
        SecondRow(),
    ],
});

const Bluetooth = await Service.import('bluetooth');
const Network = await Service.import('network');

const { Box, Icon, Label, Revealer } = Widget;
const { execAsync } = Utils;

import { SpeakerIcon, MicIcon } from '../misc/audio-icons.ts';
import CursorBox from '../misc/cursorbox.ts';
import Separator from '../misc/separator.ts';

import { NetworkMenu } from './network.ts';
import { BluetoothMenu } from './bluetooth.ts';

// Types
import GObject from 'types/@girs/gobject-2.0/gobject-2.0';
import AgsBox from 'types/widgets/box.ts';
import AgsIcon from 'types/widgets/icon.ts';
import AgsLabel from 'types/widgets/label.ts';
import AgsRevealer from 'types/widgets/revealer.ts';
import { Variable as Var } from 'types/variable.ts';
type IconTuple = [
    GObject.Object,
    (self: AgsIcon) => void,
    signal?: string,
];
type IndicatorTuple = [
    GObject.Object,
    (self: AgsLabel) => void,
    signal?: string,
];
type GridButtonType = {
    command?(): void
    secondary_command?(): void
    on_open?(menu: AgsRevealer): void
    icon: string | IconTuple
    indicator?: IndicatorTuple
    menu?: any
};

const SPACING = 28;
const ButtonStates = [] as Array<Var<any>>;


const GridButton = ({
    command = () => {/**/},
    secondary_command = () => {/**/},
    on_open = () => {/**/},
    icon,
    indicator,
    menu,
}: GridButtonType) => {
    const Activated = Variable(false);

    ButtonStates.push(Activated);
    let iconWidget = Icon();
    let indicatorWidget = Label();

    // Allow setting icon dynamically or statically
    if (typeof icon === 'string') {
        iconWidget = Icon({
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
    else if (Array.isArray(icon)) {
        iconWidget = Icon({
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
        indicatorWidget = Label({
            class_name: 'sub-label',
            justification: 'left',
            truncate: 'end',
            max_width_chars: 12,
            setup: (self) => {
                self.hook(...indicator);
            },
        });
    }

    if (menu) {
        menu = Revealer({
            transition: 'slide_down',
            child: menu,
            reveal_child: Activated.bind(),
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

                        child: iconWidget,
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
                                    ((((self.get_parent() as AgsBox)
                                        ?.get_parent() as AgsBox)
                                        ?.get_parent() as AgsBox)
                                        ?.get_parent() as AgsBox)
                                        ?.children[1] as AgsBox;

                                const isSetup = (rowMenu
                                    .get_children() as Array<AgsBox>)
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
                                        on_open(menu);
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
            indicatorWidget,
        ],
    });

    return widget;
};

const Row = ({ buttons }) => {
    const child = Box({
        class_name: 'button-row',
        hpack: 'center',
    });

    const widget = Box({
        vertical: true,

        children: [
            child,
            Box({ vertical: true }),
        ],
    });

    for (let i = 0; i < buttons.length; ++i) {
        if (i === buttons.length - 1) {
            child.add(buttons[i]);
        }
        else {
            child.add(buttons[i]);
            child.add(Separator(SPACING));
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

            icon: [Network, (self) => {
                self.icon = Network.wifi?.icon_name;
            }],

            indicator: [Network, (self) => {
                self.label = Network.wifi?.ssid || Network.wired?.internet;
            }],

            menu: NetworkMenu(),
            on_open: () => Network.wifi.scan(),
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
                    self.icon = Bluetooth.connected_devices[0] ?
                        Bluetooth.connected_devices[0].icon_name :
                        'bluetooth-active-symbolic';
                }
                else {
                    self.icon = 'bluetooth-disabled-symbolic';
                }
            }],

            indicator: [Bluetooth, (self) => {
                self.label = Bluetooth.connected_devices[0] ?
                    `${Bluetooth.connected_devices[0]}` :
                    'Disconnected';
            }, 'notify::connected-devices'],

            menu: BluetoothMenu(),
            on_open: (menu) => {
                execAsync(`bluetoothctl scan ${menu.reveal_child ?
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

        // TODO: replace this with Rotation Toggle and move lock to a separate section
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

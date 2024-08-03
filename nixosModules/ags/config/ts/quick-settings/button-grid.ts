const Bluetooth = await Service.import('bluetooth');
const Network = await Service.import('network');

import Tablet from '../../services/tablet.ts';

const { Box, Icon, Label, Revealer } = Widget;
const { execAsync } = Utils;

import { SpeakerIcon, MicIcon } from '../misc/audio-icons.ts';
import CursorBox from '../misc/cursorbox.ts';
import Separator from '../misc/separator.ts';

import { NetworkMenu } from './network.ts';
import { BluetoothMenu } from './bluetooth.ts';

/* Types */
import GObject from 'types/@girs/gobject-2.0/gobject-2.0';
import { Variable as Var } from 'types/variable.ts';

import {
    BoxGeneric,
    IconGeneric,
    LabelGeneric,
    RevealerGeneric,
} from 'global-types';

type IconTuple = [
    GObject.Object,
    (self: IconGeneric, state?: boolean) => void,
    signal?: string,
];

type IndicatorTuple = [
    GObject.Object,
    (self: LabelGeneric) => void,
    signal?: string,
];

interface GridButtonType {
    command?(): void
    secondary_command?(): void
    on_open?(menu: RevealerGeneric): void
    icon: string | IconTuple
    indicator?: IndicatorTuple
    // @ts-expect-error me is lazy
    menu?: Widget
}


// TODO: do vpn button
const SPACING = 28;
const ButtonStates = [] as Var<boolean>[];

const GridButton = ({
    command = () => { /**/ },
    secondary_command = () => { /**/ },
    on_open = () => { /**/ },
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
                                    state.setValue(false);
                                }
                            });
                            Activated.setValue(!Activated.value);
                        },

                        on_hover: (self) => {
                            if (menu) {
                                const rowMenu =
                                    ((((self.get_parent() as BoxGeneric)
                                        ?.get_parent() as BoxGeneric)
                                        ?.get_parent() as BoxGeneric)
                                        ?.get_parent() as BoxGeneric)
                                        ?.children[1] as BoxGeneric;

                                const isSetup = (rowMenu
                                    .get_children() as BoxGeneric[])
                                    .find((ch) => ch === menu);

                                if (!isSetup) {
                                    rowMenu.add(menu);
                                    rowMenu.show_all();
                                }
                            }
                        },

                        child: Icon({
                            icon: 'down-large-symbolic',
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

        GridButton({
            command: () => {
                execAsync(['lock']).catch(print);
            },
            secondary_command: () => App.openWindow('win-powermenu'),
            icon: 'system-lock-screen-symbolic',
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
                if (Tablet.autorotateState) {
                    Tablet.killAutorotate();
                }
                else {
                    Tablet.startAutorotate();
                }
            },

            icon: [Tablet, (self, state) => {
                self.icon = state ?
                    'screen-rotate-auto-on-symbolic' :
                    'screen-rotate-auto-off-symbolic';
            }, 'autorotate-toggled'],
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

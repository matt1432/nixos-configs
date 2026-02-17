import { createBinding, createState, With } from 'ags';
import { Astal, Gtk } from 'ags/gtk3';
import AstalNetwork from 'gi://AstalNetwork';

import { getWindow } from '../../../lib';

export default () => {
    const network = AstalNetwork.get_default();

    const [isHovered, setIsHovered] = createState(false);

    return (
        <cursor-button
            class="bar-item network"
            cursor="pointer"
            onHover={() => setIsHovered(true)}
            onHoverLost={() => setIsHovered(false)}
            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-network')!;

                win.set_x_pos(self.get_allocation(), 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <With value={createBinding(network, 'primary')}>
                {(primary) => {
                    if (primary === AstalNetwork.Primary.UNKNOWN) {
                        return (
                            <icon icon="network-wireless-signal-none-symbolic" />
                        ) as Astal.Icon;
                    }
                    else if (primary === AstalNetwork.Primary.WIFI) {
                        const Wifi = network.get_wifi();

                        if (!Wifi || Wifi.get_access_points().length === 0) {
                            return (
                                <icon icon="network-wireless-signal-none-symbolic" />
                            ) as Astal.Icon;
                        }

                        return (
                            <box>
                                <icon icon={createBinding(Wifi, 'iconName')} />

                                <revealer
                                    revealChild={isHovered}
                                    transitionType={
                                        Gtk.RevealerTransitionType.SLIDE_LEFT
                                    }
                                >
                                    <With
                                        value={createBinding(
                                            Wifi,
                                            'activeAccessPoint',
                                        )}
                                    >
                                        {(ap: AstalNetwork.AccessPoint) =>
                                            ap && (
                                                <label
                                                    label={createBinding(
                                                        ap,
                                                        'ssid',
                                                    )}
                                                />
                                            )
                                        }
                                    </With>
                                </revealer>
                            </box>
                        ) as Astal.Box;
                    }
                    else {
                        const Wired = network.get_wired();

                        if (!Wired) {
                            return (
                                <icon icon="network-wireless-signal-none-symbolic" />
                            ) as Astal.Icon;
                        }

                        return (
                            <icon icon={createBinding(Wired, 'iconName')} />
                        ) as Astal.Icon;
                    }
                }}
            </With>
        </cursor-button>
    );
};

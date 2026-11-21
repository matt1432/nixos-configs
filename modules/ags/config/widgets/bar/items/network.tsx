import { createBinding, createState, With } from 'ags';
import { Gtk } from 'ags/gtk4';
import AstalNetwork from 'gi://AstalNetwork';

import { getWindow } from '../../../lib';
import { pointer } from '../../../lib/widgets';

export default () => {
    const network = AstalNetwork.get_default();

    const [isHovered, setIsHovered] = createState(false);

    return (
        <button
            class="bar-item network"
            cursor={pointer}
            onClicked={(self) => {
                const win = getWindow('win-network')!;

                win.set_x_pos(self, 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <Gtk.EventControllerMotion
                onEnter={() => setIsHovered(true)}
                onLeave={() => setIsHovered(false)}
            />

            <box>
                <With value={createBinding(network, 'primary')}>
                    {(primary) => {
                        if (primary === AstalNetwork.Primary.UNKNOWN) {
                            return (
                                <image iconName="network-wireless-signal-none-symbolic" />
                            );
                        }
                        else if (primary === AstalNetwork.Primary.WIFI) {
                            const Wifi = network.get_wifi();

                            if (
                                !Wifi ||
                                Wifi.get_access_points().length === 0
                            ) {
                                return (
                                    <image iconName="network-wireless-signal-none-symbolic" />
                                );
                            }

                            return (
                                <box>
                                    <image
                                        iconName={createBinding(
                                            Wifi,
                                            'iconName',
                                        )}
                                    />

                                    <revealer
                                        revealChild={isHovered}
                                        transitionType={
                                            Gtk.RevealerTransitionType
                                                .SLIDE_LEFT
                                        }
                                    >
                                        <box>
                                            <With
                                                value={createBinding(
                                                    Wifi,
                                                    'activeAccessPoint',
                                                )}
                                            >
                                                {(
                                                    ap: AstalNetwork.AccessPoint | null,
                                                ) =>
                                                    ap && (
                                                        <label
                                                            label={createBinding(
                                                                ap,
                                                                'ssid',
                                                            ).as(
                                                                (v) => v ?? '',
                                                            )}
                                                        />
                                                    )
                                                }
                                            </With>
                                        </box>
                                    </revealer>
                                </box>
                            );
                        }
                        else {
                            const Wired = network.get_wired();

                            if (!Wired) {
                                return (
                                    <image iconName="network-wireless-signal-none-symbolic" />
                                );
                            }

                            return (
                                <image
                                    iconName={createBinding(Wired, 'iconName')}
                                />
                            );
                        }
                    }}
                </With>
            </box>
        </button>
    );
};

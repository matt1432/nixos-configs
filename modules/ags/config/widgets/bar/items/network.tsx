import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalNetwork from 'gi://AstalNetwork';

/* Types */
import { getWindow } from '../../../lib';


export default () => {
    const network = AstalNetwork.get_default();

    const Hovered = Variable(false);

    return (
        <button
            className="bar-item network"
            cursor="pointer"

            onHover={() => Hovered.set(true)}
            onHoverLost={() => Hovered.set(false)}

            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-network')!;

                win.set_x_pos(
                    self.get_allocation(),
                    'right',
                );

                win.set_visible(!win.get_visible());
            }}
        >
            {bind(network, 'primary').as((primary) => {
                if (primary === AstalNetwork.Primary.UNKNOWN) {
                    return (<icon icon="network-wireless-signal-none-symbolic" />);
                }
                else if (primary === AstalNetwork.Primary.WIFI) {
                    const Wifi = network.get_wifi();

                    if (!Wifi || Wifi.get_access_points().length === 0) { return; }

                    return (
                        <box>
                            <icon icon={bind(Wifi, 'iconName')} />

                            <revealer
                                revealChild={bind(Hovered)}
                                transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
                            >
                                {bind(Wifi, 'activeAccessPoint').as((ap) => ap && (
                                    <label label={bind(ap, 'ssid')} />
                                ))}
                            </revealer>
                        </box>
                    );
                }
                else {
                    const Wired = network.get_wired();

                    if (!Wired) { return; }

                    return (<icon icon={bind(Wired, 'iconName')} />);
                }
            })}
        </button>
    );
};

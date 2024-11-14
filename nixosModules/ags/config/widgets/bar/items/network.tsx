import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalNetwork from 'gi://AstalNetwork';
const Network = AstalNetwork.get_default();


export default () => {
    const Hovered = Variable(false);

    return (
        <button
            className="bar-item network"
            cursor="pointer"

            onHover={() => Hovered.set(true)}
            onHoverLost={() => Hovered.set(false)}
        >
            {bind(Network, 'primary').as((primary) => {
                if (primary === AstalNetwork.Primary.UNKNOWN) {
                    return (<icon icon="network-wireless-signal-none-symbolic" />);
                }
                else if (primary === AstalNetwork.Primary.WIFI) {
                    const Wifi = Network.get_wifi();

                    if (!Wifi) { return; }

                    return (
                        <box>
                            <icon icon={bind(Wifi, 'iconName')} />

                            <revealer
                                revealChild={bind(Hovered)}
                                transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
                            >
                                {bind(Wifi, 'activeAccessPoint').as((ap) => (
                                    <label label={bind(ap, 'ssid')} />
                                ))}
                            </revealer>
                        </box>
                    );
                }
                else {
                    const Wired = Network.get_wired();

                    if (!Wired) { return; }

                    return (<icon icon={bind(Wired, 'iconName')} />);
                }
            })}
        </button>
    );
};

import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalNetwork from 'gi://AstalNetwork';


export default () => {
    const network = AstalNetwork.get_default();

    const Hovered = Variable(false);

    return (
        <button
            className="bar-item network"
            cursor="pointer"

            onEnterNotifyEvent={() => Hovered.set(true)}
            onLeaveNotifyEvent={() => Hovered.set(false)}
        >
            {bind(network, 'primary').as((primary) => {
                if (primary === AstalNetwork.Primary.UNKNOWN) {
                    return (<icon icon="network-wireless-signal-none-symbolic" />);
                }
                else if (primary === AstalNetwork.Primary.WIFI) {
                    const Wifi = network.get_wifi();

                    if (!Wifi) { return; }

                    return (
                        <box>
                            {/* Make sure the AP is there before binding to it */}
                            {bind(Wifi, 'accessPoints').as((aps) => {
                                if (aps.length === 0) { return; }

                                return (
                                    <>
                                        <icon icon={bind(Wifi, 'iconName')} />

                                        <revealer
                                            revealChild={bind(Hovered)}
                                            transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
                                        >
                                            {bind(Wifi, 'activeAccessPoint').as((ap) => ap && (
                                                <label label={bind(ap, 'ssid')} />
                                            ))}
                                        </revealer>
                                    </>
                                );
                            })}
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

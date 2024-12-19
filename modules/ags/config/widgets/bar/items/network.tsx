import { bind, Variable } from 'astal';
import { App, Gtk } from 'astal/gtk3';

import AstalNetwork from 'gi://AstalNetwork';

/* Types */
import PopupWindow from '../../misc/popup-window';


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
                const win = App.get_window('win-network') as PopupWindow;

                win.set_x_pos(
                    self.get_allocation(),
                    'right',
                );

                win.visible = !win.visible;
            }}
        >
            {bind(network, 'primary').as((primary) => {
                if (primary === AstalNetwork.Primary.UNKNOWN) {
                    return (<icon icon="network-wireless-signal-none-symbolic" />);
                }
                else if (primary === AstalNetwork.Primary.WIFI) {
                    const Wifi = network.get_wifi();

                    if (!Wifi || Wifi.accessPoints.length === 0) { return; }

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

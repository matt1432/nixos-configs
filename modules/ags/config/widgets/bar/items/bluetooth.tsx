import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalBluetooth from 'gi://AstalBluetooth';

import { getWindow } from '../../../lib';


export default () => {
    const bluetooth = AstalBluetooth.get_default();

    const Hovered = Variable(false);

    return (
        <button
            className="bar-item bluetooth"
            cursor="pointer"

            onHover={() => Hovered.set(true)}
            onHoverLost={() => Hovered.set(false)}

            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-bluetooth')!;

                win.set_x_pos(
                    self.get_allocation(),
                    'right',
                );

                win.set_visible(!win.get_visible());
            }}
        >
            {bind(bluetooth, 'isPowered').as((isPowered) => {
                if (!isPowered) {
                    return (<icon icon="bluetooth-disabled-symbolic" />);
                }
                else {
                    return (
                        <box>
                            {bind(bluetooth, 'isConnected').as((isConnected) => {
                                const device = bluetooth
                                    .get_devices()
                                    .find((dev) => dev.get_connected());

                                if (!isConnected || !device) {
                                    return (<icon icon="bluetooth-active-symbolic" />);
                                }
                                else {
                                    return (
                                        <>
                                            <icon icon={bind(device, 'icon')} />

                                            <revealer
                                                revealChild={bind(Hovered)}
                                                transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
                                            >
                                                <label label={bind(device, 'name')} />
                                            </revealer>
                                        </>
                                    );
                                }
                            })}
                        </box>
                    );
                }
            })}
        </button>
    );
};

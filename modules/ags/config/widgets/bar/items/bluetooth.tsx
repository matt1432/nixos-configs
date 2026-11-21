import { createBinding, createState, With } from 'ags';
import { Gtk } from 'ags/gtk4';
import AstalBluetooth from 'gi://AstalBluetooth';

import { getWindow } from '../../../lib';
import { pointer } from '../../../lib/widgets';

export default () => {
    const bluetooth = AstalBluetooth.get_default();

    const [isHovered, setIsHovered] = createState(false);

    return (
        <button
            class="bar-item bluetooth"
            cursor={pointer}
            onClicked={(self) => {
                const win = getWindow('win-bluetooth')!;

                win.set_x_pos(self, 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <Gtk.EventControllerMotion
                onEnter={() => setIsHovered(true)}
                onLeave={() => setIsHovered(false)}
            />

            <box>
                <With value={createBinding(bluetooth, 'isPowered')}>
                    {(isPowered: boolean) => {
                        if (!isPowered) {
                            return (
                                <image iconName="bluetooth-disabled-symbolic" />
                            );
                        }

                        return (
                            <box>
                                <With
                                    value={createBinding(
                                        bluetooth,
                                        'isConnected',
                                    )}
                                >
                                    {(isConnected: boolean) => {
                                        const device = bluetooth
                                            .get_devices()
                                            .find((dev) => dev.get_connected());

                                        if (!isConnected || !device) {
                                            return (
                                                <image iconName="bluetooth-active-symbolic" />
                                            );
                                        }

                                        return (
                                            <box>
                                                <image
                                                    iconName={createBinding(
                                                        device,
                                                        'icon',
                                                    )}
                                                />

                                                <revealer
                                                    revealChild={isHovered}
                                                    transitionType={
                                                        Gtk
                                                            .RevealerTransitionType
                                                            .SLIDE_LEFT
                                                    }
                                                >
                                                    <label
                                                        label={createBinding(
                                                            device,
                                                            'name',
                                                        )}
                                                    />
                                                </revealer>
                                            </box>
                                        );
                                    }}
                                </With>
                            </box>
                        );
                    }}
                </With>
            </box>
        </button>
    );
};

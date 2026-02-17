import { createBinding, createState, With } from 'ags';
import { Gtk } from 'ags/gtk3';
import AstalBluetooth from 'gi://AstalBluetooth';

import { getWindow } from '../../../lib';

export default () => {
    const bluetooth = AstalBluetooth.get_default();

    const [isHovered, setIsHovered] = createState(false);

    return (
        <cursor-button
            class="bar-item bluetooth"
            cursor="pointer"
            onHover={() => setIsHovered(true)}
            onHoverLost={() => setIsHovered(false)}
            onButtonReleaseEvent={(self) => {
                const win = getWindow('win-bluetooth')!;

                win.set_x_pos(self.get_allocation(), 'right');

                win.set_visible(!win.get_visible());
            }}
        >
            <With value={createBinding(bluetooth, 'isPowered')}>
                {(isPowered: boolean) => {
                    if (!isPowered) {
                        return <icon icon="bluetooth-disabled-symbolic" />;
                    }
                    else {
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
                                                <icon icon="bluetooth-active-symbolic" />
                                            );
                                        }
                                        else {
                                            return (
                                                <>
                                                    <icon
                                                        icon={createBinding(
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
                                                </>
                                            );
                                        }
                                    }}
                                </With>
                            </box>
                        );
                    }
                }}
            </With>
        </cursor-button>
    );
};

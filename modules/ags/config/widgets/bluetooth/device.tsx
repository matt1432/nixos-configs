import { createBinding, createRoot } from 'ags';
import { register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk3';
import { idle } from 'ags/time';
import AstalBluetooth from 'gi://AstalBluetooth';

import Separator from '../misc/separator';

interface DevToggleProps {
    label: string;
    prop: 'blocked' | 'trusted' | 'paired' | 'connected';
    onToggle: (active: boolean) => void;
}

@register()
export default class DeviceWidget extends Gtk.Revealer {
    readonly dev: AstalBluetooth.Device =
        // it is assigned right after `super` so it's never going to be null
        null as unknown as AstalBluetooth.Device;

    dispose: (() => void) | null = null;

    constructor({ dev }: { dev: AstalBluetooth.Device }) {
        super({
            revealChild: false,
            transitionType: Gtk.RevealerTransitionType.SLIDE_DOWN,
        });
        this.dev = dev;

        createRoot((dispose) => {
            this.dispose = dispose;
            const bluetooth = AstalBluetooth.get_default();

            const DevToggle = ({ label, prop, onToggle }: DevToggleProps) => (
                <centerbox>
                    <label
                        $type="start"
                        label={label}
                        valign={Gtk.Align.CENTER}
                        halign={Gtk.Align.START}
                    />

                    <box $type="center" />

                    <cursor-switch
                        $type="end"
                        cursor="pointer"
                        valign={Gtk.Align.CENTER}
                        halign={Gtk.Align.END}
                        active={createBinding(dev, prop).as(Boolean)}
                        $={(self) => {
                            self.connect('notify::active', () => {
                                onToggle(self.active);
                            });
                        }}
                    />
                </centerbox>
            );

            const rev = (
                <revealer
                    transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                >
                    <box vertical halign={Gtk.Align.FILL} hexpand>
                        <Separator size={8} vertical />

                        <DevToggle
                            label="Connected"
                            prop="connected"
                            onToggle={(active) => {
                                if (active) {
                                    dev.connect_device();
                                }
                                else {
                                    dev.disconnect_device();
                                }
                            }}
                        />

                        <Separator size={8} vertical />

                        <DevToggle
                            label="Trusted"
                            prop="trusted"
                            onToggle={(active) => {
                                dev.set_trusted(active);
                            }}
                        />

                        <Separator size={8} vertical />

                        <DevToggle
                            label="Paired"
                            prop="paired"
                            onToggle={(active) => {
                                if (active) {
                                    dev.pair();
                                }
                                else {
                                    bluetooth.get_adapter()?.remove_device(dev);
                                }
                            }}
                        />

                        <Separator size={8} vertical />

                        <DevToggle
                            label="Blocked"
                            prop="blocked"
                            onToggle={(active) => {
                                dev.set_blocked(active);
                            }}
                        />

                        <Separator size={8} vertical />
                    </box>
                </revealer>
            ) as Gtk.Revealer;

            const button = (
                <cursor-button
                    cursor="pointer"
                    onButtonReleaseEvent={() => {
                        rev.set_reveal_child(!rev.get_reveal_child());
                    }}
                >
                    <box>
                        <icon
                            icon={createBinding(dev, 'connected').as(
                                (isConnected) =>
                                    isConnected
                                        ? 'check-active-symbolic'
                                        : 'check-mixed-symbolic',
                            )}
                            css={createBinding(dev, 'paired').as((isPaired) =>
                                isPaired ? '' : 'opacity: 0;',
                            )}
                        />

                        <Separator size={8} />

                        <icon
                            icon={createBinding(dev, 'icon').as((iconName) =>
                                iconName
                                    ? `${iconName}-symbolic`
                                    : 'help-browser-symbolic',
                            )}
                        />

                        <Separator size={8} />

                        <label label={createBinding(dev, 'name')} />
                    </box>
                </cursor-button>
            );

            this.add(
                (
                    <box vertical>
                        {button}
                        {rev}
                        <Separator size={8} vertical />
                    </box>
                ) as Astal.Box,
            );
            this.show_all();

            this.connect('realize', () =>
                idle(() => {
                    this.set_reveal_child(true);
                }),
            );
        });
    }
}

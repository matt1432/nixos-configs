import { createBinding, createRoot } from 'ags';
import { register } from 'ags/gobject';
import { Gtk } from 'ags/gtk4';
import { idle } from 'ags/time';
import AstalBluetooth from 'gi://AstalBluetooth';

import { pointer } from '../../lib/widgets';
import Separator from '../misc/separator';

interface DevToggleProps {
    label: string;
    prop: 'blocked' | 'trusted' | 'paired' | 'connected';
    toggle: (active: boolean) => void;
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

            const DevToggle = ({ label, prop, toggle }: DevToggleProps) => (
                <centerbox>
                    <label
                        $type="start"
                        label={label}
                        valign={Gtk.Align.CENTER}
                        halign={Gtk.Align.START}
                    />

                    <box $type="center" />

                    <switch
                        $type="end"
                        cursor={pointer}
                        valign={Gtk.Align.CENTER}
                        halign={Gtk.Align.END}
                        active={createBinding(dev, prop).as(Boolean)}
                        onNotifyActive={(self) => {
                            // Only react to user changes, not to the binding
                            if (self.active !== Boolean(dev[prop])) {
                                toggle(self.active);
                            }
                        }}
                    />
                </centerbox>
            );

            const rev = (
                <revealer
                    transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                >
                    <box
                        orientation={Gtk.Orientation.VERTICAL}
                        halign={Gtk.Align.FILL}
                        hexpand
                    >
                        <Separator size={8} vertical />

                        <DevToggle
                            label="Connected"
                            prop="connected"
                            toggle={(active) => {
                                if (active) {
                                    dev.connect_device().catch(console.error);
                                }
                                else {
                                    dev.disconnect_device().catch(
                                        console.error,
                                    );
                                }
                            }}
                        />

                        <Separator size={8} vertical />

                        <DevToggle
                            label="Trusted"
                            prop="trusted"
                            toggle={(active) => {
                                dev.set_trusted(active);
                            }}
                        />

                        <Separator size={8} vertical />

                        <DevToggle
                            label="Paired"
                            prop="paired"
                            toggle={(active) => {
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
                            toggle={(active) => {
                                dev.set_blocked(active);
                            }}
                        />

                        <Separator size={8} vertical />
                    </box>
                </revealer>
            ) as Gtk.Revealer;

            const button = (
                <button
                    cursor={pointer}
                    onClicked={() => {
                        rev.set_reveal_child(!rev.get_reveal_child());
                    }}
                >
                    <box>
                        <image
                            iconName={createBinding(dev, 'connected').as(
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

                        <image
                            iconName={createBinding(dev, 'icon').as(
                                (iconName) =>
                                    iconName
                                        ? `${iconName}-symbolic`
                                        : 'help-browser-symbolic',
                            )}
                        />

                        <Separator size={8} />

                        <label label={createBinding(dev, 'name')} />
                    </box>
                </button>
            );

            this.set_child(
                (
                    <box orientation={Gtk.Orientation.VERTICAL}>
                        {button}
                        {rev}
                        <Separator size={8} vertical />
                    </box>
                ) as Gtk.Box,
            );

            this.connect('realize', () =>
                idle(() => {
                    this.set_reveal_child(true);
                }),
            );
        });
    }
}

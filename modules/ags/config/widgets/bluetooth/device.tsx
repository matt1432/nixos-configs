import { bind, idle } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';
import { register } from 'astal/gobject';

import AstalBluetooth from 'gi://AstalBluetooth';

import Separator from '../misc/separator';

/* Types */
interface DevToggleProps {
    label: string
    prop: keyof AstalBluetooth.Device
    onToggle: (active: boolean) => void
}


@register()
export default class DeviceWidget extends Widget.Revealer {
    readonly dev: AstalBluetooth.Device;

    constructor({ dev }: { dev: AstalBluetooth.Device }) {
        const bluetooth = AstalBluetooth.get_default();

        const DevToggle = ({ label, prop, onToggle }: DevToggleProps) => (
            <centerbox>
                <label
                    label={label}
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.START}
                />

                <box />

                <switch
                    cursor="pointer"
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.END}

                    active={bind(dev, prop).as(Boolean)}

                    setup={(self) => {
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
                                bluetooth.adapter.remove_device(dev);
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
        ) as Widget.Revealer;

        const button = (
            <button
                cursor="pointer"
                onButtonReleaseEvent={() => {
                    rev.revealChild = !rev.revealChild;
                }}
            >
                <box>
                    <icon
                        icon={bind(dev, 'connected').as((isConnected) => isConnected ?
                            'check-active-symbolic' :
                            'check-mixed-symbolic')}

                        css={bind(dev, 'paired').as((isPaired) => isPaired ?
                            '' :
                            'opacity: 0;')}
                    />

                    <Separator size={8} />

                    <icon
                        icon={bind(dev, 'icon').as((iconName) =>
                            iconName ? `${iconName}-symbolic` : 'help-browser-symbolic')}
                    />

                    <Separator size={8} />

                    <label label={bind(dev, 'name')} />
                </box>
            </button>
        );

        super({
            revealChild: false,
            transitionType: Gtk.RevealerTransitionType.SLIDE_DOWN,

            child: (
                <box vertical>
                    {button}
                    {rev}
                    <Separator size={8} vertical />
                </box>
            ),
        });

        this.dev = dev;

        this.connect('realize', () => idle(() => {
            this.revealChild = true;
        }));
    };
};

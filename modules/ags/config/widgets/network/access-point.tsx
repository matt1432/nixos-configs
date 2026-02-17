import { register } from 'ags/gobject';
import { Astal, Gtk } from 'ags/gtk3';
import { execAsync } from 'ags/process';
import AstalNetwork from 'gi://AstalNetwork';
import { createBinding, createRoot, onCleanup } from 'gnim';

import { notifySend } from '../../lib';
import Separator from '../misc/separator';

const apCommand = (ap: AstalNetwork.AccessPoint, cmd: string[]): void => {
    execAsync(['nmcli', ...cmd, ap.get_ssid()!])
        .catch((e) =>
            notifySend({
                title: 'Network',
                iconName: ap.get_icon_name(),
                body: (e as Error).message,
                actions: [
                    {
                        id: 'open',
                        label: 'Open network manager',
                        callback: () => execAsync('nm-connection-editor'),
                    },
                ],
            }),
        )
        .catch((e) => console.error(e));
};

const apConnect = (ap: AstalNetwork.AccessPoint): void => {
    execAsync(['nmcli', 'connection', 'show', ap.get_ssid()!])
        .catch(() => apCommand(ap, ['device', 'wifi', 'connect']))
        .then(() => apCommand(ap, ['connection', 'up']));
};

const apDisconnect = (ap: AstalNetwork.AccessPoint): void => {
    apCommand(ap, ['connection', 'down']);
};

@register()
export default class AccessPointWidget extends Astal.Box {
    aps: AstalNetwork.AccessPoint[] = [];

    dispose: (() => void) | null = null;

    getStrongest() {
        return this.aps.sort(
            (apA, apB) => apB.get_strength() - apA.get_strength(),
        )[0];
    }

    constructor({ aps }: { aps: AstalNetwork.AccessPoint[] }) {
        super({
            orientation: Gtk.Orientation.VERTICAL,
        });
        this.aps = aps;

        createRoot((dispose) => {
            this.dispose = dispose;

            const wifi = AstalNetwork.get_default().get_wifi();

            if (!wifi) {
                throw new Error('Could not find wifi device.');
            }

            const rev = (
                <revealer
                    transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
                >
                    <box vertical halign={Gtk.Align.FILL} hexpand>
                        <Separator size={8} vertical />

                        <centerbox>
                            <label
                                $type="start"
                                label="Connected"
                                valign={Gtk.Align.CENTER}
                                halign={Gtk.Align.START}
                            />

                            <box $type="center" />

                            <cursor-switch
                                $type="end"
                                cursor="pointer"
                                valign={Gtk.Align.CENTER}
                                halign={Gtk.Align.END}
                                state={createBinding(
                                    wifi,
                                    'activeAccessPoint',
                                ).as((activeAp) => aps.includes(activeAp))}
                                onButtonReleaseEvent={(self) => {
                                    if (self.state) {
                                        apDisconnect(this.getStrongest());
                                    }
                                    else {
                                        apConnect(this.getStrongest());
                                    }
                                }}
                            />
                        </centerbox>

                        <Separator size={8} vertical />
                    </box>
                </revealer>
            ) as Gtk.Revealer;

            const button = (
                <cursor-button
                    cursor="pointer"
                    onButtonReleaseEvent={() => {
                        rev.revealChild = !rev.revealChild;
                    }}
                >
                    <box>
                        <icon
                            icon="check-active-symbolic"
                            css={createBinding(wifi, 'activeAccessPoint').as(
                                (activeAp) =>
                                    aps.includes(activeAp) ? '' : 'opacity: 0;',
                            )}
                        />

                        <Separator size={8} />

                        <icon icon={createBinding(aps[0], 'iconName')} />

                        <Separator size={8} />

                        <label label={aps[0].get_ssid()!} />
                    </box>
                </cursor-button>
            ) as Astal.Button;

            this.set_children([
                button,
                rev,
                (<Separator size={8} vertical />) as Gtk.Widget,
            ]);
            this.show_all();
        });

        // Ran by `For` in ./main.tsx
        onCleanup(() => {
            this.dispose?.();
        });
    }
}

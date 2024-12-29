import { bind, execAsync } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';
import { register } from 'astal/gobject';

import AstalNetwork from 'gi://AstalNetwork';

import Separator from '../misc/separator';
import { notifySend } from '../../lib';


const apCommand = (ap: AstalNetwork.AccessPoint, cmd: string[]): void => {
    execAsync([
        'nmcli',
        ...cmd,
        ap.get_ssid()!,
    ]).catch((e) => notifySend({
        title: 'Network',
        iconName: ap.get_icon_name(),
        body: (e as Error).message,
        actions: [
            {
                id: 'open',
                label: 'Open network manager',
                callback: () =>
                    execAsync('nm-connection-editor'),
            },
        ],
    })).catch((e) => console.error(e));
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
export default class AccessPointWidget extends Widget.Box {
    readonly aps: AstalNetwork.AccessPoint[];

    getStrongest() {
        return this.aps.sort((apA, apB) => apB.get_strength() - apA.get_strength())[0];
    }

    constructor({ aps }: { aps: AstalNetwork.AccessPoint[] }) {
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
                            label="Connected"
                            valign={Gtk.Align.CENTER}
                            halign={Gtk.Align.START}
                        />

                        <box />

                        <switch
                            cursor="pointer"
                            valign={Gtk.Align.CENTER}
                            halign={Gtk.Align.END}

                            state={bind(wifi, 'activeAccessPoint')
                                .as((activeAp) => aps.includes(activeAp))}

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
                        icon="check-active-symbolic"

                        css={bind(wifi, 'activeAccessPoint').as((activeAp) => aps.includes(activeAp) ?
                            '' :
                            'opacity: 0;')}
                    />

                    <Separator size={8} />

                    <icon
                        icon={bind(aps[0], 'iconName')}
                    />

                    <Separator size={8} />

                    <label label={aps[0].get_ssid()!} />
                </box>
            </button>
        );

        super({
            vertical: true,
            children: [
                button,
                rev,
                (<Separator size={8} vertical />),
            ],
        });

        this.aps = aps;
    };
};

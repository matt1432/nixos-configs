import GObject, { register } from 'ags/gobject';
import { Gtk } from 'ags/gtk4';
import { execAsync } from 'ags/process';
import AstalNetwork from 'gi://AstalNetwork';
import {
    Accessor,
    createBinding,
    createComputed,
    createRoot,
    createState,
    onCleanup,
    Setter,
} from 'gnim';

import { notifySend } from '../../lib';
import { pointer } from '../../lib/widgets';
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

/**
 * All the access points sharing an SSID, stored in the ListView's model.
 */
@register()
export class ApGroup extends GObject.Object {
    declare ssid: string;
    declare aps: Accessor<AstalNetwork.AccessPoint[]>;
    declare setAps: Setter<AstalNetwork.AccessPoint[]>;

    getStrongest() {
        return [...this.aps()].sort(
            (apA, apB) => apB.get_strength() - apA.get_strength(),
        )[0];
    }

    get strength() {
        return this.getStrongest()?.get_strength() ?? 0;
    }

    constructor(ssid: string, aps: AstalNetwork.AccessPoint[]) {
        super();
        this.ssid = ssid;
        [this.aps, this.setAps] = createState(aps);
    }
}

@register()
export default class AccessPointWidget extends Gtk.Box {
    dispose: (() => void) | null = null;

    constructor({ group }: { group: ApGroup }) {
        super({
            orientation: Gtk.Orientation.VERTICAL,
        });

        createRoot((dispose) => {
            this.dispose = dispose;

            const wifi = AstalNetwork.get_default().get_wifi();

            if (!wifi) {
                throw new Error('Could not find wifi device.');
            }

            const activeAp = createBinding(wifi, 'activeAccessPoint');
            const isActive = createComputed(() =>
                group.aps().includes(activeAp() as AstalNetwork.AccessPoint),
            );

            // Follow the icon of the strongest access point
            const [iconName, setIconName] = createState('');
            let iconAp: AstalNetwork.AccessPoint | undefined;
            let iconId: number | undefined;

            const followStrongest = () => {
                if (iconAp && iconId !== undefined) {
                    iconAp.disconnect(iconId);
                }

                iconAp = group.getStrongest();
                setIconName(iconAp?.get_icon_name() ?? '');

                iconId = iconAp?.connect('notify::icon-name', () => {
                    setIconName(iconAp?.get_icon_name() ?? '');
                });
            };

            followStrongest();
            const unsub = group.aps.subscribe(followStrongest);

            onCleanup(() => {
                unsub();

                if (iconAp && iconId !== undefined) {
                    iconAp.disconnect(iconId);
                }
            });

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

                        <centerbox>
                            <label
                                $type="start"
                                label="Connected"
                                valign={Gtk.Align.CENTER}
                                halign={Gtk.Align.START}
                            />

                            <box $type="center" />

                            <switch
                                $type="end"
                                cursor={pointer}
                                valign={Gtk.Align.CENTER}
                                halign={Gtk.Align.END}
                                active={isActive}
                                state={isActive}
                                onStateSet={(_, state) => {
                                    // The binding also triggers this signal
                                    if (state !== isActive()) {
                                        if (state) {
                                            apConnect(group.getStrongest());
                                        }
                                        else {
                                            apDisconnect(group.getStrongest());
                                        }
                                    }

                                    // The state is only changed by the binding
                                    return true;
                                }}
                            />
                        </centerbox>

                        <Separator size={8} vertical />
                    </box>
                </revealer>
            ) as Gtk.Revealer;

            const button = (
                <button
                    cursor={pointer}
                    onClicked={() => {
                        rev.revealChild = !rev.revealChild;
                    }}
                >
                    <box>
                        <image
                            iconName="check-active-symbolic"
                            css={isActive.as((active) =>
                                active ? '' : 'opacity: 0;',
                            )}
                        />

                        <Separator size={8} />

                        <image iconName={iconName} />

                        <Separator size={8} />

                        <label label={group.ssid} />
                    </box>
                </button>
            ) as Gtk.Button;

            this.append(button);
            this.append(rev);
            this.append((<Separator size={8} vertical />) as Gtk.Widget);
        });
    }
}

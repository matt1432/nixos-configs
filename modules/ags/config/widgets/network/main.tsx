import { bind, Variable } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalNetwork from 'gi://AstalNetwork';

import { ToggleButton } from '../misc/subclasses';
import Separator from '../misc/separator';

import AccessPointWidget from './access-point';


export default () => {
    const wifi = AstalNetwork.get_default().get_wifi();

    if (!wifi) {
        throw new Error('Could not find wifi device.');
    }

    const IsRefreshing = Variable<boolean>(false);
    const AccessPoints = Variable<AstalNetwork.AccessPoint[]>(wifi.get_access_points());

    wifi.connect('notify::access-points', () => {
        if (IsRefreshing.get()) {
            AccessPoints.set(wifi.get_access_points());
        }
    });

    IsRefreshing.subscribe(() => {
        if (IsRefreshing.get()) {
            AccessPoints.set(wifi.get_access_points());
        }
    });

    const apList = (
        <scrollable
            className="list"

            css="min-height: 300px;"
            hscroll={Gtk.PolicyType.NEVER}
            vscroll={Gtk.PolicyType.AUTOMATIC}
        >
            <box vertical>
                {bind(AccessPoints).as(() => {
                    const joined = new Map<string, AstalNetwork.AccessPoint[]>();

                    AccessPoints.get()
                        .filter((ap) => ap.get_ssid())
                        .sort((apA, apB) => {
                            const sort = apB.get_strength() - apA.get_strength();

                            return sort !== 0 ?
                                sort :
                                apA.get_ssid()!.localeCompare(apB.get_ssid()!);
                        })
                        .forEach((ap) => {
                            const arr = joined.get(ap.get_ssid()!);

                            if (arr) {
                                arr.push(ap);
                            }
                            else {
                                joined.set(ap.get_ssid()!, [ap]);
                            }
                        });

                    return [...joined.values()].map((aps) => <AccessPointWidget aps={aps} />);
                })}
            </box>
        </scrollable>
    );

    return (
        <box
            className="network widget"
            vertical
        >
            <centerbox homogeneous>
                <switch
                    cursor="pointer"
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.START}

                    active={bind(wifi, 'enabled')}

                    setup={(self) => {
                        self.connect('notify::active', () => {
                            wifi.set_enabled(self.active);
                        });
                    }}
                />

                <box />

                <ToggleButton
                    cursor="pointer"
                    halign={Gtk.Align.END}

                    className="toggle-button"

                    sensitive={bind(wifi, 'enabled')}
                    active={bind(IsRefreshing)}

                    onToggled={(self) => {
                        self.toggleClassName('active', self.active);
                        IsRefreshing.set(self.active);
                    }}
                >
                    <icon icon="emblem-synchronizing-symbolic" css="font-size: 30px;" />
                </ToggleButton>
            </centerbox>

            <Separator size={8} vertical />

            {apList}
        </box>
    );
};

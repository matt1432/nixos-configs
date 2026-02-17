import { createBinding, createState, For } from 'ags';
import { Gtk } from 'ags/gtk3';
import AstalNetwork from 'gi://AstalNetwork';

import { toggleClassName } from '../../lib/widgets';
import Separator from '../misc/separator';
import { ToggleButton } from '../misc/subclasses';
import AccessPointWidget from './access-point';

export default () => {
    const wifi = AstalNetwork.get_default().get_wifi();

    if (!wifi) {
        throw new Error('Could not find wifi device.');
    }

    const [isRefreshing, setIsRefreshing] = createState(false);
    const [accessPoints, setAccessPoints] = createState<
        AstalNetwork.AccessPoint[]
    >(wifi.get_access_points());

    // FIXME: doesn't update?
    wifi.connect('notify::access-points', () => {
        if (isRefreshing()) {
            setAccessPoints(wifi.get_access_points());
        }
    });

    isRefreshing.subscribe(() => {
        if (isRefreshing()) {
            setAccessPoints(wifi.get_access_points());
        }
    });

    const apList = (
        <scrollable
            class="list"
            css="min-height: 300px;"
            hscroll={Gtk.PolicyType.NEVER}
            vscroll={Gtk.PolicyType.AUTOMATIC}
        >
            <box vertical>
                <For
                    each={accessPoints.as(() => {
                        const joined = new Map<
                            string,
                            AstalNetwork.AccessPoint[]
                        >();

                        accessPoints()
                            .filter((ap) => ap.get_ssid())
                            .sort((apA, apB) => {
                                const sort =
                                    apB.get_strength() - apA.get_strength();

                                return sort !== 0
                                    ? sort
                                    : apA
                                          .get_ssid()!
                                          .localeCompare(apB.get_ssid()!);
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

                        return [...joined.values()];
                    })}
                >
                    {(aps: AstalNetwork.AccessPoint[]) => (
                        <AccessPointWidget aps={aps} />
                    )}
                </For>
            </box>
        </scrollable>
    );

    return (
        <box class="network widget" vertical>
            <centerbox homogeneous>
                <cursor-switch
                    $type="start"
                    cursor="pointer"
                    valign={Gtk.Align.CENTER}
                    halign={Gtk.Align.START}
                    active={createBinding(wifi, 'enabled')}
                    $={(self) => {
                        self.connect('notify::active', () => {
                            wifi.set_enabled(self.active);
                        });
                    }}
                />

                <box $type="center" />

                <ToggleButton
                    $type="end"
                    cursor="pointer"
                    halign={Gtk.Align.END}
                    class="toggle-button"
                    sensitive={createBinding(wifi, 'enabled')}
                    active={isRefreshing}
                    onToggled={(self) => {
                        toggleClassName(self, 'active', self.active);
                        setIsRefreshing(self.active);
                    }}
                >
                    <icon
                        icon="emblem-synchronizing-symbolic"
                        css="font-size: 30px;"
                    />
                </ToggleButton>
            </centerbox>

            <Separator size={8} vertical />

            {apList}
        </box>
    );
};

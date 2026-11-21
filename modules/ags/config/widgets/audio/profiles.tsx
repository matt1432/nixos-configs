import { Gtk } from 'ags/gtk4';
import AstalWp from 'gi://AstalWp';
import { Accessor, createBinding, For } from 'gnim';

import { pointer } from '../../lib/widgets';

export default (devices: Accessor<AstalWp.Device[]>) => (
    <For
        each={devices.as((arr) =>
            arr.sort(
                (a, b) =>
                    a.description?.localeCompare(b.description ?? '') ?? -1,
            ),
        )}
    >
        {(device: AstalWp.Device) => {
            const profiles = (device.get_profiles() ?? []).sort((a, b) => {
                if (a.get_description() === 'Off') {
                    return 1;
                }
                else if (b.get_description() === 'Off') {
                    return -1;
                }
                else {
                    return a
                        .get_description()
                        .localeCompare(b.get_description());
                }
            });

            return (
                <box class="device" orientation={Gtk.Orientation.VERTICAL}>
                    <label
                        label={createBinding(device, 'description').as(
                            (v) => v ?? '',
                        )}
                    />

                    <Gtk.DropDown
                        cursor={pointer}
                        model={Gtk.StringList.new(
                            profiles.map((p) => p.get_description()),
                        )}
                        $={(self) => {
                            const active = profiles.indexOf(
                                device.get_profile(
                                    device.get_active_profile_id(),
                                )!,
                            );

                            if (active >= 0) {
                                self.set_selected(active);
                            }

                            // Connect after setting the initial value
                            self.connect('notify::selected', () => {
                                const profile = profiles[self.get_selected()];

                                if (profile) {
                                    device.set_active_profile_id(
                                        profile.get_index(),
                                    );
                                }
                            });
                        }}
                    />
                </box>
            ) as Gtk.Box;
        }}
    </For>
);

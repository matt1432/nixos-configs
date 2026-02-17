import { Astal } from 'ags/gtk3';
import AstalWp from 'gi://AstalWp';
import { Accessor, createBinding, For } from 'gnim';

import { ComboBoxText } from '../misc/subclasses';

export default (devices: Accessor<AstalWp.Device[]>) => {
    return (
        <For
            each={devices.as((arr) =>
                arr.sort((a, b) => a.description.localeCompare(b.description)),
            )}
        >
            {(device: AstalWp.Device) =>
                (
                    <box class="stream" vertical>
                        <label label={createBinding(device, 'description')} />

                        <ComboBoxText
                            $={(self) => {
                                const profiles = (
                                    device.get_profiles() ?? []
                                ).sort((a, b) => {
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

                                profiles.forEach((profile) => {
                                    self.append(
                                        profile.get_index().toString(),
                                        profile.get_description(),
                                    );
                                });

                                self.set_active(
                                    profiles.indexOf(
                                        device.get_profile(
                                            device.get_active_profile_id(),
                                        )!,
                                    ),
                                );
                            }}
                            onChanged={(self) => {
                                const activeId = self.get_active_id();

                                if (activeId) {
                                    device.set_active_profile_id(
                                        parseInt(activeId),
                                    );
                                }
                            }}
                        />
                    </box>
                ) as Astal.Box
            }
        </For>
    );
};

import { bind } from 'astal';

import AstalWp from 'gi://AstalWp';

import { ComboBoxText } from '../misc/subclasses';


export default (devices: AstalWp.Device[]) => devices
    .sort((a, b) => a.get_description().localeCompare(b.description))
    .map((device) => (
        <box className="stream" vertical>

            <label label={bind(device, 'description')} />

            <ComboBoxText
                setup={(self) => {
                    const profiles = (device.get_profiles() ?? []).sort((a, b) => {
                        if (a.get_description() === 'Off') {
                            return 1;
                        }
                        else if (b.get_description() === 'Off') {
                            return -1;
                        }
                        else {
                            return a.get_description().localeCompare(b.get_description());
                        }
                    });

                    profiles.forEach((profile) => {
                        self.append(profile.get_index().toString(), profile.get_description());
                    });

                    self.set_active(
                        profiles.indexOf(
                            device.get_profile(device.get_active_profile_id())!,
                        ),
                    );
                }}

                onChanged={(self) => {
                    const activeId = self.get_active_id();

                    if (activeId) {
                        device.set_active_profile_id(parseInt(activeId));
                    }
                }}
            />

        </box>
    ));

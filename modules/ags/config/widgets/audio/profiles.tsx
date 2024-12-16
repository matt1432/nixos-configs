import { bind } from 'astal';

import AstalWp from 'gi://AstalWp';

import { ComboBoxText } from '../misc/subclasses';


export default (devices: AstalWp.Device[]) => devices
    .sort((a, b) => a.description.localeCompare(b.description))
    .map((device) => (
        <box className="stream" vertical>

            <label label={bind(device, 'description')} />

            <ComboBoxText
                setup={(self) => {
                    const profiles = (device.get_profiles() ?? []).sort((a, b) => {
                        if (a.description === 'Off') {
                            return 1;
                        }
                        else if (b.description === 'Off') {
                            return -1;
                        }
                        else {
                            return a.description.localeCompare(b.description);
                        }
                    });

                    profiles.forEach((profile) => {
                        self.append(profile.index.toString(), profile.description);
                    });

                    self.set_active(
                        profiles.indexOf(
                            device.get_profile(device.get_active_profile())!,
                        ),
                    );
                }}

                onChanged={(self) => {
                    device.set_active_profile(parseInt(self.activeId));
                }}
            />

        </box>
    ));

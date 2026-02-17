import { createBinding } from 'ags';
import AstalBattery from 'gi://AstalBattery';

import { toggleClassName } from '../../../lib/widgets';
import Separator from '../../misc/separator';

const LOW_BATT = 20;

export default () => {
    const battery = AstalBattery.get_default();

    return (
        <box class="bar-item battery">
            <icon
                $={(self) => {
                    const update = () => {
                        const percent = Math.round(
                            battery.get_percentage() * 100,
                        );
                        const level = Math.floor(percent / 10) * 10;
                        const isCharging = battery.get_charging();
                        const charged = percent === 100 && isCharging;
                        const iconName = charged
                            ? 'battery-level-100-charged-symbolic'
                            : `battery-level-${level}${
                                  isCharging ? '-charging' : ''
                              }-symbolic`;

                        self.set_icon(iconName);

                        toggleClassName(self, 'charging', isCharging);
                        toggleClassName(self, 'charged', charged);
                        toggleClassName(self, 'low', percent < LOW_BATT);
                    };

                    update();

                    battery.connect('notify::percentage', () => update());
                    battery.connect('notify::icon-name', () => update());
                    battery.connect('notify::battery-icon-name', () =>
                        update(),
                    );
                }}
            />

            <Separator size={8} />

            <label
                label={createBinding(battery, 'percentage').as(
                    (v) => `${Math.round(v * 100)}%`,
                )}
            />
        </box>
    );
};

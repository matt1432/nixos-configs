import { bind, Widget } from 'astal';

import AstalBattery from 'gi://AstalBattery';
const Battery = AstalBattery.get_default();

import Separator from '../../misc/separator';


const LOW_BATT = 20;
const SPACING = 8;

export default () => (
    <box className="bar-item battery">
        <icon
            setup={(self: Widget.Icon) => {
                const update = () => {
                    const percent = Math.round(Battery.get_percentage() * 100);
                    const level = Math.floor(percent / 10) * 10;
                    const isCharging = Battery.get_charging();
                    const charged = percent === 100 && isCharging;
                    const iconName = charged ?
                        'battery-level-100-charged-symbolic' :
                        `battery-level-${level}${isCharging ?
                            '-charging' :
                            ''}-symbolic`;

                    self.set_icon(iconName);

                    self.toggleClassName('charging', isCharging);
                    self.toggleClassName('charged', charged);
                    self.toggleClassName('low', percent < LOW_BATT);
                };

                update();

                Battery.connect('notify::percentage', () => update());
            }}
        />

        <Separator size={SPACING} />

        <label label={bind(Battery, 'percentage').as((v) => `${Math.round(v * 100)}%`)} />
    </box>
);

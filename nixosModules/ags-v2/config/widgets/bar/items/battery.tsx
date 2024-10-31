import { bind } from 'astal';

import AstalBattery from 'gi://AstalBattery';
const Battery = AstalBattery.get_default();

import Separator from '../../misc/separator';


const LOW_BATT = 20;

export default () => (
    <box className="bar-item battery">
        <icon
            setup={(self) => {
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
                Battery.connect('notify::icon-name', () => update());
                Battery.connect('notify::battery-icon-name', () => update());
            }}
        />

        <Separator size={8} />

        <label label={bind(Battery, 'percentage').as((v) => `${Math.round(v * 100)}%`)} />
    </box>
);

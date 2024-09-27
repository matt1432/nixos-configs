import { bind, Widget } from 'astal';

import AstalBattery from 'gi://AstalBattery';
const Battery = AstalBattery.get_default();

import Separator from '../../misc/separator';


const LOW_BATT = 20;
const SPACING = 5;

export default () => (
    <box className="bar-item battery">
        <icon
            icon={bind(Battery, 'batteryIconName')}

            setup={(self: Widget.Icon) => {
                Battery.connect('notify::percentage', () => {
                    const percent = Math.round(Battery.get_percentage() * 100);

                    self.toggleClassName('charging', Battery.get_charging());
                    self.toggleClassName('charged', percent === 100);
                    self.toggleClassName('low', percent < LOW_BATT);
                });
            }}
        />

        <Separator size={SPACING} />

        <label label={bind(Battery, 'percentage').as((v) => `${Math.round(v * 100)}%`)} />
    </box>
);

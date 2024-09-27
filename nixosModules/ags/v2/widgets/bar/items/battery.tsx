import { bind, Widget } from 'astal';

import AstalBattery from 'gi://AstalBattery';
const Battery = AstalBattery.get_default();

import Separator from '../../misc/separator';


const LOW_BATT = 20;
const SPACING = 5;

export default () => (
    <box className="toggle-off battery">
        <icon
            class_name="battery-indicator"
            icon={bind(Battery, 'batteryIconName')}

            setup={(self: Widget.Icon) => {
                Battery.connect('notify::percentage', () => {
                    self.toggleClassName('charging', Battery.get_charging());
                    self.toggleClassName('charged', Battery.get_percentage() === 100);
                    self.toggleClassName('low', Battery.get_percentage() < LOW_BATT);
                });
            }}
        />

        <Separator size={SPACING} />

        <label label={bind(Battery, 'percentage').as((v) => `${v}%`)} />
    </box>
);

import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js';
import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

const DEFAULT_KB = 'at-translated-set-2-keyboard';

export default () => Box({
    className: 'toggle-off',
    children: [
        Icon({
            icon: 'input-keyboard-symbolic',
            style: 'margin-right: 4px;',
        }),
        Label({
            connections: [[Hyprland, (self, _n, layout) => {
                if (!layout) {
                    const obj = exec('hyprctl devices -j');
                    const keyboards = JSON.parse(obj)['keyboards'];
                    const kb = keyboards.find(val => val.name === DEFAULT_KB);

                    layout = kb['active_keymap'];

                    self.label = layout;
                }
                else {
                    self.label = layout;
                }
            }, 'keyboard-layout']],
        }),
    ],
});

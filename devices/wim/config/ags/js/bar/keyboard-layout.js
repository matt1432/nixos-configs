import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { Box, Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

const DEFAULT_KB = 'at-translated-set-2-keyboard';

export default () => Box({
    className: 'toggle-off',
    css: 'padding: 0 10px;',
    children: [
        Icon({
            icon: 'input-keyboard-symbolic',
            css: 'margin-right: 4px;',
        }),
        Label({
            connections: [[Hyprland, (self, _n, layout) => {
                if (!layout) {
                    Hyprland.sendMessage('j/devices').then(obj => {
                        const kb = JSON.parse(obj)['keyboards']
                            .find(val => val.name === DEFAULT_KB);

                        layout = kb['active_keymap'];

                        const shortName = layout.match(/\(([A-Za-z]+)\)/);

                        self.label = shortName ? shortName[1] : layout;
                    }).catch(print);
                }
                else {
                    if (layout === 'error')
                        return;

                    const shortName = layout.match(/\(([A-Za-z]+)\)/);

                    self.label = shortName ? shortName[1] : layout;
                }
            }, 'keyboard-layout']],
        }),
    ],
});

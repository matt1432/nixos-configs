import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import HoverRevealer from './hover-revealer.js';

const DEFAULT_KB = 'at-translated-set-2-keyboard';


/**
 * @param {import('types/widgets/label').default} self
 * @param {string} layout
 * @param {string} _
 */
const getKbdLayout = (self, _, layout) => {
    if (layout) {
        if (layout === 'error') {
            return;
        }

        const shortName = layout.match(/\(([A-Za-z]+)\)/);

        self.label = shortName ? shortName[1] : layout;
    }
    else {
        // At launch, kb layout is undefined
        Hyprland.sendMessage('j/devices').then((obj) => {
            const kb = Array.from(JSON.parse(obj).keyboards)
                .find((v) => v.name === DEFAULT_KB);

            layout = kb['active_keymap'];

            const shortName = layout
                .match(/\(([A-Za-z]+)\)/);

            self.label = shortName ? shortName[1] : layout;
        }).catch(print);
    }
};

export default () => HoverRevealer({
    class_name: 'keyboard',
    spacing: 4,

    icon: Icon({
        icon: 'input-keyboard-symbolic',
        size: 20,
    }),
    label: Label({ css: 'font-size: 20px;' })
        .hook(Hyprland, getKbdLayout, 'keyboard-layout'),
});

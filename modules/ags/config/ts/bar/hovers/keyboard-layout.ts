import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Icon, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import HoverRevealer from './hover-revealer.ts';

const DEFAULT_KB = 'at-translated-set-2-keyboard';

import AgsLabel from 'types/widgets/label.ts';
type Keyboard = {
    address: string;
    name: string;
    rules: string;
    model: string;
    layout: string;
    variant: string;
    options: string;
    active_keymap: string;
    main: boolean;
};



const getKbdLayout = (self: AgsLabel, _: string, layout: string) => {
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
            const keyboards = Array.from(JSON.parse(obj)
                .keyboards) as Array<Keyboard>;
            const kb = keyboards.find((v) => v.name === DEFAULT_KB);

            if (kb) {
                layout = kb.active_keymap;

                const shortName = layout
                    .match(/\(([A-Za-z]+)\)/);

                self.label = shortName ? shortName[1] : layout;
            }
            else {
                self.label = 'None';
            }
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

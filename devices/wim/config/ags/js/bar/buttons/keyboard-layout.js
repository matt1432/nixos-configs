import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, EventBox, Icon, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const DEFAULT_KB = 'at-translated-set-2-keyboard';
const SPACING = 4;


/**
 * @param {Label} self
 * @param {string} layout
 * @param {void} _
 */
const getKbdLayout = (self, _, layout) => {
    if (layout) {
        if (layout === 'error') {
            return;
        }

        const shortName = layout.match(/\(([A-Za-z]+)\)/);

        // @ts-expect-error
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

            // @ts-expect-error
            self.label = shortName ? shortName[1] : layout;
        }).catch(print);
    }
};

export default () => {
    const hoverRevLabel = Revealer({
        transition: 'slide_right',

        child: Box({

            children: [
                Separator(SPACING),

                Label({ css: 'font-size: 20px;' })
                    .hook(Hyprland, getKbdLayout, 'keyboard-layout'),
            ],
        }),
    });

    const widget = EventBox({
        on_hover: () => {
            hoverRevLabel.reveal_child = true;
        },
        on_hover_lost: () => {
            hoverRevLabel.reveal_child = false;
        },

        child: Box({
            css: 'padding: 0 10px; margin-right: -10px;',

            children: [
                Icon({
                    icon: 'input-keyboard-symbolic',
                    size: 20,
                }),

                hoverRevLabel,
            ],
        }),
    });

    return widget;
};

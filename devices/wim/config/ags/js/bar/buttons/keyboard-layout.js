import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

import { Box, EventBox, Icon, Label, Revealer } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../../misc/separator.js';

const DEFAULT_KB = 'at-translated-set-2-keyboard';
const SPACING = 4;


export default () => {
    const rev = Revealer({
        transition: 'slide_right',
        child: Box({
            children: [
                Separator(SPACING),
                Label({
                    css: 'font-size: 20px;',
                    connections: [[Hyprland, (self, _n, layout) => {
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
                                const kb = JSON.parse(obj).keyboards
                                    .find((val) => val.name === DEFAULT_KB);

                                layout = kb['active_keymap'];

                                const shortName = layout
                                    .match(/\(([A-Za-z]+)\)/);

                                self.label = shortName ? shortName[1] : layout;
                            }).catch(print);
                        }
                    }, 'keyboard-layout']],
                }),
            ],
        }),
    });

    const widget = EventBox({
        onHover: () => {
            rev.revealChild = true;
        },
        onHoverLost: () => {
            rev.revealChild = false;
        },
        child: Box({
            css: 'padding: 0 10px; margin-right: -10px;',
            children: [
                Icon({
                    icon: 'input-keyboard-symbolic',
                    size: 20,
                }),

                rev,
            ],
        }),
    });

    widget.rev = rev;

    return widget;
};

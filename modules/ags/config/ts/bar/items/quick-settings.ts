const { Box, Label } = Widget;

import Audio from '../hovers/audio.ts';
import Bluetooth from '../hovers/bluetooth.ts';
import Brightness from '../hovers/brightness.ts';
import KeyboardLayout from '../hovers/keyboard-layout.ts';
import Network from '../hovers/network.ts';

import CursorBox from '../../misc/cursorbox.ts';
import Separator from '../../misc/separator.ts';

const SPACING = 4;

// Types
import { PopupWindow } from 'global-types';


export default () => {
    const hoverRevealers = [
        KeyboardLayout(),

        Brightness(),

        Audio(),

        Bluetooth(),

        Network(),
    ];

    return CursorBox({
        class_name: 'toggle-off',

        on_primary_click_release: (self) => {
            (App.getWindow('quick-settings') as PopupWindow)
                .set_x_pos(
                    self.get_allocation(),
                    'right',
                );

            App.toggleWindow('quick-settings');
        },

        setup: (self) => {
            self.hook(App, (_, windowName, visible) => {
                if (windowName === 'quick-settings') {
                    self.toggleClassName('toggle-on', visible);
                }
            });
        },

        attribute: {
            hoverRevealers: hoverRevealers.map((rev) => {
                const box = rev.child;

                return box.children[1];
            }),
        },
        on_hover_lost: (self) => {
            self.attribute.hoverRevealers.forEach((rev) => {
                rev.reveal_child = false;
            });
        },

        child: Box({
            class_name: 'quick-settings-toggle',
            vertical: false,
            children: [
                Separator(SPACING),

                ...hoverRevealers,

                Label(' '),

                Separator(SPACING),
            ],
        }),
    });
};

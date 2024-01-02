import App from 'resource:///com/github/Aylur/ags/app.js';

import { Box, Label } from 'resource:///com/github/Aylur/ags/widget.js';

import Audio from '../hovers/audio.js';
import Bluetooth from '../hovers/bluetooth.js';
import Brightness from '../hovers/brightness.js';
import KeyboardLayout from '../hovers/keyboard-layout.js';
import Network from '../hovers/network.js';

import CursorBox from '../../misc/cursorbox.js';
import Separator from '../../misc/separator.js';

const SPACING = 4;


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
            // @ts-expect-error
            App.getWindow('quick-settings').attribute.set_x_pos(
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
            hoverRevealers: hoverRevealers.map(
                // @ts-expect-error
                (rev) => rev.child.children[1],
            ),
        },
        on_hover_lost: (self) => {
            self.attribute.hoverRevealers.forEach(
                /** @param {import('types/widgets/revealer').default} rev */
                (rev) => {
                    rev.reveal_child = false;
                },
            );
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

import { Box, CenterBox, Label, ToggleButton } from 'resource:///com/github/Aylur/ags/widget.js';

import Separator from '../misc/separator.js';
import RoundedCorner from '../corners/screen-corners.js';
import Key from './keys.js';

import { defaultOskLayout, oskLayouts } from './keyboard-layouts.js';
const keyboardLayout = defaultOskLayout;
const keyboardJson = oskLayouts[keyboardLayout];

const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4]; // eslint-disable-line
const COLOR = 'rgba(0, 0, 0, 0.3)';
const SPACING = 4;


export default (window) => Box({
    vertical: true,
    children: [
        CenterBox({
            hpack: 'center',

            start_widget: RoundedCorner('bottomright', `
                background-color: ${COLOR};
            `),

            center_widget: CenterBox({
                class_name: 'thingy',
                css: `background: ${COLOR};`,
                center_widget: Box({
                    hpack: 'center',
                    class_name: 'settings',

                    children: [
                        ToggleButton({
                            cursor: 'pointer',
                            class_name: 'button',
                            active: true,
                            vpack: 'center',

                            connections: [['toggled', (self) => {
                                self.toggleClassName(
                                    'toggled',
                                    self.get_active(),
                                );
                                window.exclusivity = self.get_active() ?
                                    'exclusive' :
                                    'normal';
                            }]],

                            child: Label('Exclusive'),
                        }),
                    ],
                }),
            }),

            end_widget: RoundedCorner('bottomleft', `
                background-color: ${COLOR};
            `),
        }),

        CenterBox({
            css: `background: ${COLOR};`,
            class_name: 'osk',
            hexpand: true,

            start_widget: Box({
                class_name: 'left-side side',
                hpack: 'start',
                vertical: true,

                children: keyboardJson.keys.map((row, rowIndex) => Box({
                    vertical: true,

                    children: [
                        Box({
                            class_name: 'row',

                            children: [
                                Separator(SPACING),
                                ...row.map((key, keyIndex) => {
                                    return keyIndex < L_KEY_PER_ROW[rowIndex] ?
                                        Key(key) :
                                        null;
                                }),
                            ],
                        }),

                        Separator(SPACING, { vertical: true }),
                    ],
                })),
            }),

            center_widget: Box({
                hpack: 'center',
                vpack: 'center',

                children: [
                ],
            }),

            end_widget: Box({
                class_name: 'right-side side',
                hpack: 'end',
                vertical: true,

                children: keyboardJson.keys.map((row, rowIndex) => Box({
                    vertical: true,

                    children: [
                        Box({
                            hpack: 'end',
                            class_name: 'row',

                            children: row.map((key, keyIndex) => {
                                return keyIndex >= L_KEY_PER_ROW[rowIndex] ?
                                    Key(key) :
                                    null;
                            }),
                        }),

                        Separator(SPACING, { vertical: true }),
                    ],
                })),
            }),
        }),
    ],
});

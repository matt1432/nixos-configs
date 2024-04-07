const { Box, CenterBox, Label, ToggleButton } = Widget;

const { Gdk } = imports.gi;
const display = Gdk.Display.get_default();

import Separator from '../misc/separator.ts';
import RoundedCorner from '../corners/screen-corners.ts';
import Key from './keys.ts';

import { defaultOskLayout, oskLayouts } from './keyboard-layouts.ts';
const keyboardLayout = defaultOskLayout;
const keyboardJson = oskLayouts[keyboardLayout];

const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4]; // eslint-disable-line
const COLOR = 'rgba(0, 0, 0, 0.3)';
const SPACING = 4;

// Types
import { BoxGeneric, OskWindow } from 'global-types';


export default (window: OskWindow) => Box({
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
                            class_name: 'button',
                            active: true,
                            vpack: 'center',

                            setup: (self) => {
                                self
                                    .on('toggled', () => {
                                        self.toggleClassName(
                                            'toggled',
                                            self.get_active(),
                                        );
                                        window.exclusivity = self.get_active() ?
                                            'exclusive' :
                                            'normal';
                                    })

                                    // OnHover
                                    .on('enter-notify-event', () => {
                                        if (!display) {
                                            return;
                                        }
                                        self.window.set_cursor(
                                            Gdk.Cursor.new_from_name(
                                                display,
                                                'pointer',
                                            ),
                                        );
                                        self.toggleClassName('hover', true);
                                    })

                                    // OnHoverLost
                                    .on('leave-notify-event', () => {
                                        self.window.set_cursor(null);
                                        self.toggleClassName('hover', false);
                                    });
                            },

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

                children: keyboardJson.keys.map((row, rowIndex) => {
                    const keys = [] as BoxGeneric[];

                    row.forEach((key, keyIndex) => {
                        if (keyIndex < L_KEY_PER_ROW[rowIndex]) {
                            keys.push(Key(key));
                        }
                    });

                    return Box({
                        vertical: true,

                        children: [
                            Box({
                                class_name: 'row',

                                children: [
                                    Separator(SPACING),

                                    ...keys,
                                ],
                            }),

                            Separator(SPACING, { vertical: true }),
                        ],
                    });
                }),
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

                children: keyboardJson.keys.map((row, rowIndex) => {
                    const keys = [] as BoxGeneric[];

                    row.forEach((key, keyIndex) => {
                        if (keyIndex >= L_KEY_PER_ROW[rowIndex]) {
                            keys.push(Key(key));
                        }
                    });

                    return Box({
                        vertical: true,

                        children: [
                            Box({
                                hpack: 'end',
                                class_name: 'row',

                                children: keys,
                            }),

                            Separator(SPACING, { vertical: true }),
                        ],
                    });
                }),
            }),
        }),
    ],
});

import { Box, CenterBox, Label, ToggleButton } from 'resource:///com/github/Aylur/ags/widget.js';
import Separator from '../misc/separator.js';

import Key from './keys.js';

import { defaultOskLayout, oskLayouts } from './keyboard-layouts.js';
const keyboardLayout = defaultOskLayout;
const keyboardJson = oskLayouts[keyboardLayout];

const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4];


export default window => CenterBox({
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
                    children: row.map((key, keyIndex) => {
                        return keyIndex < L_KEY_PER_ROW[rowIndex] ? Key(key) : null;
                    }),
                }),
                Separator(4, { vertical: true }),
            ],
        })),
    }),

    center_widget: Box({
        hpack: 'center',
        vpack: 'center',
        children: [
            Box({
                class_name: 'settings',
                children: [
                    ToggleButton({
                        cursor: 'pointer',
                        class_name: 'button',
                        active: true,
                        vpack: 'center',
                        connections: [['toggled', self => {
                            self.toggleClassName('toggled', self.get_active());
                            window.exclusivity = self.get_active() ? 'exclusive' : 'normal';
                        }]],
                        child: Label('Exclusive'),
                    }),
                ],
            }),
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
                        return keyIndex >= L_KEY_PER_ROW[rowIndex] ? Key(key) : null;
                    }),
                }),
                Separator(4, { vertical: true }),
            ],
        })),
    }),
});

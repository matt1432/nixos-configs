import { Gtk, Widget } from 'astal/gtk3';

import Separator from '../misc/separator';

import Key from './keys';

import { defaultOskLayout, oskLayouts } from './keyboard-layouts';

const keyboardLayout = defaultOskLayout;
const keyboardJson = oskLayouts[keyboardLayout];


const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4]; // eslint-disable-line
const COLOR = 'rgba(0, 0, 0, 0.3)';
const SPACING = 4;

export default (): Widget.Box => (
    <box vertical>
        <centerbox
            css={`background: ${COLOR};`}
            className="osk"
            hexpand
        >
            <box
                className="left-side side"
                halign={Gtk.Align.START}
                vertical
            >
                {...keyboardJson.keys.map((row, rowIndex) => {
                    const keys = [] as Widget.Box[];

                    row.forEach((key, keyIndex) => {
                        if (keyIndex < L_KEY_PER_ROW[rowIndex]) {
                            keys.push(Key(key));
                        }
                    });

                    return (
                        <box vertical>
                            <box className="row">
                                <Separator size={SPACING} />

                                {...keys}
                            </box>

                            <Separator size={SPACING} vertical />
                        </box>
                    );
                })}
            </box>

            <box
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
            >
            </box>

            <box
                className="right-side side"
                halign={Gtk.Align.END}
                vertical
            >
                {...keyboardJson.keys.map((row, rowIndex) => {
                    const keys = [] as Widget.Box[];

                    row.forEach((key, keyIndex) => {
                        if (keyIndex >= L_KEY_PER_ROW[rowIndex]) {
                            keys.push(Key(key));
                        }
                    });

                    return (
                        <box vertical>

                            <box
                                halign={Gtk.Align.END}
                                className="row"
                            >
                                {...keys}
                            </box>

                            <Separator size={SPACING} vertical />
                        </box>
                    );
                })}
            </box>
        </centerbox>
    </box>
) as Widget.Box;

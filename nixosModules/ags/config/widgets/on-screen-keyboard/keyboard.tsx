import { Astal, astalify, Gtk, type ConstructProps, Widget } from 'astal/gtk3';
import { register } from 'astal/gobject';

import Separator from '../misc/separator';

import Key from './keys';

import { defaultOskLayout, oskLayouts } from './keyboard-layouts';


const keyboardLayout = defaultOskLayout;
const keyboardJson = oskLayouts[keyboardLayout];

@register()
class ToggleButton extends astalify(Gtk.ToggleButton) {
    constructor(props: ConstructProps<
        ToggleButton,
        Gtk.ToggleButton.ConstructorProps
    >) {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        super(props as any);
    }
}

const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4]; // eslint-disable-line
const COLOR = 'rgba(0, 0, 0, 0.3)';
const SPACING = 4;

export default () => (
    <box vertical>
        <centerbox
            css={`background: ${COLOR};`}
            className="osk hidden"
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
                valign={Gtk.Align.END}
            >
                <box
                    halign={Gtk.Align.CENTER}
                    className="settings"
                >
                    <ToggleButton
                        className="button"
                        cursor="pointer"
                        active
                        valign={Gtk.Align.CENTER}

                        onToggled={(self) => {
                            self.toggleClassName(
                                'toggled',
                                self.get_active(),
                            );

                            if (self.get_toplevel() === self) {
                                return;
                            }

                            (self.get_toplevel() as Widget.Window | undefined)
                                ?.set_exclusivity(
                                    self.get_active() ?
                                        Astal.Exclusivity.EXCLUSIVE :
                                        Astal.Exclusivity.NORMAL,
                                );
                        }}
                    >
                        Exclusive
                    </ToggleButton>
                </box>
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
                                className="row"
                                halign={Gtk.Align.END}
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

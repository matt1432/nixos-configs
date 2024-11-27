import { bind, idle, Variable } from 'astal';
import { Astal, astalify, Gtk, type ConstructProps, Widget } from 'astal/gtk3';
import { register } from 'astal/gobject';

import Separator from '../misc/separator';

import Arc from './arcs';
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

const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4];
const SPACING = 4;
const COLOR = 'rgba(0, 0, 0, 0.3)';

export default () => {
    const ThirdWidth = Variable(0);

    return (
        <box
            vertical
            onRealize={(self) => idle(() => {
                ThirdWidth.set(self.get_allocated_width() / 3);
            })}
        >
            <centerbox
                className="osk hidden"
                hexpand
            >
                {/* LEFT */}
                <box
                    widthRequest={bind(ThirdWidth)}
                    css={`background: ${COLOR};`}
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

                {/* MIDDLE */}
                <box
                    widthRequest={bind(ThirdWidth)}
                    halign={Gtk.Align.CENTER}
                    valign={Gtk.Align.FILL}
                    vertical
                >
                    <box
                        valign={Gtk.Align.START}
                    >
                        {bind(ThirdWidth).as((width) => (
                            <Arc
                                allocation={{ width, height: 160 }}
                                css={`background: ${COLOR};`}
                            />

                        ))}
                    </box>

                    <box
                        halign={Gtk.Align.FILL}
                        hexpand
                        vexpand
                        css={`background: ${COLOR};`}
                        className="settings"
                    >
                        <centerbox
                            halign={Gtk.Align.FILL}
                            hexpand
                            vexpand
                        >
                            <box />

                            <ToggleButton
                                className="button"
                                cursor="pointer"
                                active
                                valign={Gtk.Align.CENTER}
                                halign={Gtk.Align.CENTER}

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

                            <box />
                        </centerbox>
                    </box>
                </box>

                {/* RIGHT */}
                <box
                    widthRequest={bind(ThirdWidth)}
                    css={`background: ${COLOR};`}
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
};

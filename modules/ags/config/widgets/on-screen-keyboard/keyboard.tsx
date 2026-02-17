import { Astal, Gtk } from 'ags/gtk3';
// import { idle } from 'ags/time';
import { createState, With } from 'gnim';

import { toggleClassName } from '../../lib/widgets';
import Separator from '../misc/separator';
import { ToggleButton } from '../misc/subclasses';
import Arc from './arcs';
import { defaultOskLayout, oskLayouts } from './keyboard-layouts';
import Key from './keys';

const keyboardLayout = defaultOskLayout;
const keyboardJson = oskLayouts[keyboardLayout];

// eslint-disable-next-line no-magic-numbers
const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4];
const SPACING = 4;
const COLOR = 'rgba(0, 0, 0, 0.5)';

export default () => {
    // FIXME: get value by getting width of monitor with Tablet orientation
    // eslint-disable-next-line no-magic-numbers
    const [thirdWidth /*, setThirdWidth*/] = createState(1920 / 3);

    return (
        <box
            vertical
            /*
            onRealize={(self) =>
                idle(() => {
                    setThirdWidth(self.get_allocated_width() / 3);
                })
            }
            */
        >
            <centerbox class="osk hidden" hexpand>
                {/* LEFT */}
                <box
                    $type="start"
                    widthRequest={thirdWidth}
                    css={`
                        background: ${COLOR};
                    `}
                    class="left-side side"
                    halign={Gtk.Align.START}
                    vertical
                >
                    {...keyboardJson.keys.map((row, rowIndex) => {
                        const keys = [] as Astal.Box[];

                        row.forEach((key, keyIndex) => {
                            if (keyIndex < L_KEY_PER_ROW[rowIndex]) {
                                keys.push(Key(key));
                            }
                        });

                        return (
                            <box vertical>
                                <box class="row">
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
                    $type="center"
                    widthRequest={thirdWidth}
                    halign={Gtk.Align.CENTER}
                    valign={Gtk.Align.FILL}
                    vertical
                >
                    <box valign={Gtk.Align.START}>
                        <With value={thirdWidth}>
                            {(width) => (
                                <Arc
                                    allocation={{ width, height: 160 }}
                                    css={`
                                        background: ${COLOR};
                                    `}
                                />
                            )}
                        </With>
                    </box>

                    <box
                        halign={Gtk.Align.FILL}
                        hexpand
                        vexpand
                        css={`
                            background: ${COLOR};
                        `}
                        class="settings"
                    >
                        <centerbox halign={Gtk.Align.FILL} hexpand vexpand>
                            <box $type="start" />

                            <ToggleButton
                                $type="center"
                                class="button"
                                cursor="pointer"
                                active
                                valign={Gtk.Align.CENTER}
                                halign={Gtk.Align.CENTER}
                                onToggled={(self) => {
                                    toggleClassName(
                                        self,
                                        'toggled',
                                        self.get_active(),
                                    );

                                    if (self.get_toplevel() === self) {
                                        return;
                                    }

                                    (
                                        self.get_toplevel() as
                                            | Astal.Window
                                            | undefined
                                    )?.set_exclusivity(
                                        self.get_active()
                                            ? Astal.Exclusivity.EXCLUSIVE
                                            : Astal.Exclusivity.NORMAL,
                                    );
                                }}
                            >
                                Exclusive
                            </ToggleButton>

                            <box $type="end" />
                        </centerbox>
                    </box>
                </box>

                {/* RIGHT */}
                <box
                    $type="end"
                    widthRequest={thirdWidth}
                    css={`
                        background: ${COLOR};
                    `}
                    class="right-side side"
                    halign={Gtk.Align.END}
                    vertical
                >
                    {...keyboardJson.keys.map((row, rowIndex) => {
                        const keys = [] as Astal.Box[];

                        row.forEach((key, keyIndex) => {
                            if (keyIndex >= L_KEY_PER_ROW[rowIndex]) {
                                keys.push(Key(key));
                            }
                        });

                        return (
                            <box vertical>
                                <box class="row" halign={Gtk.Align.END}>
                                    {...keys}
                                </box>

                                <Separator size={SPACING} vertical />
                            </box>
                        );
                    })}
                </box>
            </centerbox>
        </box>
    ) as Astal.Box;
};

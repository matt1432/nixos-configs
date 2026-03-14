import { Astal, Gtk } from 'ags/gtk3';
import { idle } from 'ags/time';
import { createState, onCleanup, With } from 'gnim';

import { toggleClassName } from '../../lib/widgets';
import Tablet from '../../services/tablet';
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
    const [screenSize, setScreenSize] = createState({ height: 0, width: 0 });
    const [thirdWidth, setThirdWidth] = createState(0);

    const [keyboardLeftSideWidth, setKeyboardLeftSideWidth] = createState(0);
    const [keyboardRightSideWidth, setKeyboardRightSideWidth] = createState(0);
    const [isMiddleVisible, setIsMiddleVisible] = createState(true);
    const [middleWidth, setMiddleWidth] = createState(0);

    const id = Tablet.get_default().connect(
        'rotation-changed',
        (_, rotation) => {
            let width = screenSize().height;
            if (rotation === 0 || rotation === 2) {
                width = screenSize().width;
            }
            const _thirdWidth = width / 3;

            setIsMiddleVisible(
                _thirdWidth >= keyboardLeftSideWidth() ||
                    _thirdWidth >= keyboardRightSideWidth(),
            );
            setMiddleWidth(
                width - keyboardLeftSideWidth() - keyboardRightSideWidth(),
            );

            setThirdWidth(_thirdWidth);
        },
    );

    onCleanup(() => {
        Tablet.get_default().disconnect(id);
    });

    return (
        <box
            vertical
            onRealize={(self) => {
                idle(() => {
                    const win = self.get_window();
                    if (!win) {
                        throw Error('Window is undefined for OSK');
                    }

                    const screen = self.get_screen();
                    const rect = screen.get_monitor_geometry(
                        screen.get_monitor_at_window(win),
                    );
                    if (!rect) {
                        throw Error('Monitor geometry is undefined for OSK');
                    }

                    setScreenSize({
                        height: rect.height,
                        width: rect.width,
                    });
                    setThirdWidth(screen.get_width() / 3);
                });
            }}
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
                    onRealize={(self) => {
                        idle(() => {
                            setKeyboardLeftSideWidth(
                                self.get_allocated_width(),
                            );
                        });
                    }}
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
                <With value={isMiddleVisible}>
                    {(v) =>
                        v ? (
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
                                                allocation={{
                                                    width,
                                                    height: 160,
                                                }}
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
                                    <centerbox
                                        halign={Gtk.Align.FILL}
                                        hexpand
                                        vexpand
                                    >
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

                                                if (
                                                    self.get_toplevel() === self
                                                ) {
                                                    return;
                                                }

                                                (
                                                    self.get_toplevel() as
                                                        | Astal.Window
                                                        | undefined
                                                )?.set_exclusivity(
                                                    self.get_active()
                                                        ? Astal.Exclusivity
                                                              .EXCLUSIVE
                                                        : Astal.Exclusivity
                                                              .NORMAL,
                                                );
                                            }}
                                        >
                                            Exclusive
                                        </ToggleButton>

                                        <box $type="end" />
                                    </centerbox>
                                </box>
                            </box>
                        ) : (
                            <box
                                halign={Gtk.Align.FILL}
                                hexpand
                                vexpand
                                widthRequest={middleWidth}
                                css={`
                                    background: ${COLOR};
                                `}
                            />
                        )
                    }
                </With>

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
                    onRealize={(self) => {
                        idle(() => {
                            setKeyboardRightSideWidth(
                                self.get_allocated_width(),
                            );
                        });
                    }}
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

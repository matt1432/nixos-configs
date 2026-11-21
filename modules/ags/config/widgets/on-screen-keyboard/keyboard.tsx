import { Astal, Gdk, Gtk } from 'ags/gtk4';
import { createState, onCleanup, With } from 'gnim';

import { pointer, toggleClassName } from '../../lib/widgets';
import Tablet from '../../services/tablet';
import Separator from '../misc/separator';
import Arc from './arcs';
import { defaultOskLayout, oskLayouts } from './keyboard-layouts';
import { Key, setupKeys } from './keys';

const keyboardLayout = defaultOskLayout;
const keyboardJson = oskLayouts[keyboardLayout];

// eslint-disable-next-line no-magic-numbers
const L_KEY_PER_ROW = [8, 7, 6, 6, 6, 4];
const SPACING = 4;
const COLOR = 'rgba(0, 0, 0, 0.5)';

/**
 * Runs a callback with the widget's width once it has been allocated.
 *
 * @param self     the widget
 * @param callback what to do with the width
 */
const onAllocated = (self: Gtk.Widget, callback: (width: number) => void) => {
    self.add_tick_callback(() => {
        if (self.get_width() > 0) {
            callback(self.get_width());

            return false;
        }

        return true;
    });
};

export default () => {
    setupKeys();

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
            orientation={Gtk.Orientation.VERTICAL}
            onRealize={(self) => {
                const setGeometry = (monitor: Gdk.Monitor) => {
                    const rect = monitor.get_geometry();

                    setScreenSize({
                        height: rect.height,
                        width: rect.width,
                    });
                    setThirdWidth(rect.width / 3);
                };

                const surface = self.get_native()?.get_surface();
                if (!surface) {
                    throw Error('Window is undefined for OSK');
                }

                const monitor =
                    Gdk.Display.get_default()?.get_monitor_at_surface(surface);

                if (monitor) {
                    setGeometry(monitor);
                }
                else {
                    // The surface doesn't know its monitor until it is mapped
                    const id = surface.connect('enter-monitor', (_, mon) => {
                        surface.disconnect(id);
                        setGeometry(mon);
                    });
                }
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
                    orientation={Gtk.Orientation.VERTICAL}
                    onMap={(self) => {
                        onAllocated(self, setKeyboardLeftSideWidth);
                    }}
                >
                    {...keyboardJson.keys.map((row, rowIndex) => {
                        const keys = [] as Gtk.Box[];

                        row.forEach((key, keyIndex) => {
                            if (keyIndex < L_KEY_PER_ROW[rowIndex]) {
                                keys.push(Key(key));
                            }
                        });

                        return (
                            <box orientation={Gtk.Orientation.VERTICAL}>
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
                {/* Wrapped in a box since With can't remove children of a centerbox */}
                <box $type="center">
                    <With value={isMiddleVisible}>
                        {(v) =>
                            v ? (
                                <box
                                    widthRequest={thirdWidth}
                                    halign={Gtk.Align.CENTER}
                                    valign={Gtk.Align.FILL}
                                    orientation={Gtk.Orientation.VERTICAL}
                                >
                                    <box valign={Gtk.Align.START}>
                                        <With value={thirdWidth}>
                                            {(width) => (
                                                <Arc
                                                    allocation={{
                                                        width,
                                                        height: 160,
                                                    }}
                                                    color={COLOR}
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

                                            <togglebutton
                                                $type="center"
                                                class="button"
                                                cursor={pointer}
                                                active
                                                label="Exclusive"
                                                valign={Gtk.Align.CENTER}
                                                halign={Gtk.Align.CENTER}
                                                onToggled={(self) => {
                                                    toggleClassName(
                                                        self,
                                                        'toggled',
                                                        self.get_active(),
                                                    );

                                                    const root =
                                                        self.get_root();

                                                    if (
                                                        !(
                                                            root instanceof
                                                            Astal.Window
                                                        )
                                                    ) {
                                                        return;
                                                    }

                                                    root.set_exclusivity(
                                                        self.get_active()
                                                            ? Astal.Exclusivity
                                                                  .EXCLUSIVE
                                                            : Astal.Exclusivity
                                                                  .NORMAL,
                                                    );
                                                }}
                                            />

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
                    orientation={Gtk.Orientation.VERTICAL}
                    onMap={(self) => {
                        onAllocated(self, setKeyboardRightSideWidth);
                    }}
                >
                    {...keyboardJson.keys.map((row, rowIndex) => {
                        const keys = [] as Gtk.Box[];

                        row.forEach((key, keyIndex) => {
                            if (keyIndex >= L_KEY_PER_ROW[rowIndex]) {
                                keys.push(Key(key));
                            }
                        });

                        return (
                            <box orientation={Gtk.Orientation.VERTICAL}>
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
    ) as Gtk.Box;
};

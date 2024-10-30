import { bind, timeout } from 'astal';
import { register } from 'astal/gobject';
import { App, Astal, astalify, Gtk, Widget, type ConstructProps } from 'astal/gtk3';

import AstalWp from "gi://AstalWp"

import PopupWindow from '../misc/popup-window';
import Brightness from '../../services/brightness';

/* Types */
declare global {
    function popup_osd(osd: string): void;
}
@register()
class ProgressBar extends astalify(Gtk.ProgressBar) {
    constructor(props: ConstructProps<
        ProgressBar,
        Gtk.ProgressBar.ConstructorProps
    >) {
        super(props as any)
    }
}


const HIDE_DELAY = 2000;
const transition_duration = 300;

export default () => {
    let n_showing = 0;
    let stack: Widget.Stack | undefined;

    const popup = (osd: string) => {
        if (!stack) {
            return;
        }

        ++n_showing;
        stack.shown = osd;

        App.get_window('win-osd')?.set_visible(true);

        timeout(HIDE_DELAY, () => {
            --n_showing;

            if (n_showing === 0) {
                App.get_window('win-osd')?.set_visible(false);
            }
        });
    }

    globalThis.popup_osd = popup;

    const speaker = AstalWp.get_default()?.audio.default_speaker!;
    const microphone = AstalWp.get_default()?.audio.default_microphone!;

    return (
        <PopupWindow
            name="osd"
            anchor={Astal.WindowAnchor.BOTTOM}
            exclusivity={Astal.Exclusivity.IGNORE}
            close_on_unfocus="stay"
            transition="slide bottom"
        >
            <stack
                className="osd"
                transitionDuration={transition_duration}
                setup={(self) => {
                    timeout(1000, () => {
                        stack = self;
                    });
                }}
            >

                <box
                    name="speaker"
                    css="margin-bottom: 80px;"

                    setup={(self) => {
                        self.hook(speaker, 'notify::mute', () => {
                            popup('speaker');
                        });
                    }}
                >
                    <box className="osd-item widget">
                        <icon icon={bind(speaker, 'volumeIcon')} />

                        <ProgressBar
                            fraction={bind(speaker, 'volume')}
                            sensitive={bind(speaker, 'mute').as((v) => !v)}
                            valign={Gtk.Align.CENTER}
                        />
                    </box>
                </box>

                <box
                    name="microphone"
                    css="margin-bottom: 80px;"

                    setup={(self) => {
                        self.hook(microphone, 'notify::mute', () => {
                            popup('microphone');
                        });
                    }}
                >
                    <box className="osd-item widget">
                        <icon icon={bind(microphone, 'volumeIcon')} />

                        <ProgressBar
                            fraction={bind(microphone, 'volume')}
                            sensitive={bind(microphone, 'mute').as((v) => !v)}
                            valign={Gtk.Align.CENTER}
                        />
                    </box>
                </box>

                <box
                    name="brightness"
                    css="margin-bottom: 80px;"

                    setup={(self) => {
                        self.hook(Brightness, 'notify::screen-icon', () => {
                            popup('brightness');
                        });
                    }}
                >
                    <box className="osd-item widget">
                        <icon icon={bind(Brightness, 'screenIcon')} />

                        <ProgressBar
                            fraction={bind(Brightness, 'screen')}
                            valign={Gtk.Align.CENTER}
                        />
                    </box>
                </box>

                <box
                    name="keyboard"
                    css="margin-bottom: 80px;"

                    setup={(self) => {
                        self.hook(Brightness, 'notify::kbd-level', () => {
                            popup('keyboard');
                        });
                    }}
                >
                    <box className="osd-item widget">
                        <icon icon="keyboard-brightness-symbolic" />

                        <ProgressBar
                            fraction={bind(Brightness, 'kbdLevel').as((v) => v / 2)}
                            sensitive={bind(Brightness, 'kbdLevel').as((v) => v !== 0)}
                            valign={Gtk.Align.CENTER}
                        />
                    </box>
                </box>

                <box
                    name="caps"
                    css="margin-bottom: 80px;"

                    setup={(self) => {
                        self.hook(Brightness, 'notify::caps-icon', () => {
                            popup('caps');
                        });
                    }}
                >
                    <box className="osd-item widget">
                        <icon icon={bind(Brightness, 'capsIcon')} />

                        <label label="Caps Lock" />
                    </box>
                </box>

            </stack>
        </PopupWindow>
    );
};
import { Astal, Gtk } from 'ags/gtk3';
import { timeout } from 'ags/time';
import AstalWp from 'gi://AstalWp';
import { createBinding } from 'gnim';

import { getWindow } from '../../lib';
import Brightness from '../../services/brightness';
import PopupWindow from '../misc/popup-window';
import { ProgressBar } from '../misc/subclasses';

declare global {
    function popup_osd(osd: string): void;
}

const HIDE_DELAY = 2000;
const transition_duration = 300;

export default () => {
    let n_showing = 0;
    let stack: Astal.Stack | undefined;

    const popup = (osd: string) => {
        if (!stack) {
            return;
        }

        ++n_showing;
        stack.visibleChildName = osd;

        getWindow('win-osd')?.set_visible(true);

        timeout(HIDE_DELAY, () => {
            --n_showing;

            if (n_showing === 0) {
                getWindow('win-osd')?.set_visible(false);
            }
        });
    };

    globalThis.popup_osd = popup;

    const brightness = Brightness.get_default();
    const speaker = AstalWp.get_default()?.get_audio()?.get_default_speaker();
    const microphone = AstalWp.get_default()
        ?.get_audio()
        ?.get_default_microphone();

    if (!speaker || !microphone) {
        throw new Error('Could not find default audio devices.');
    }

    const content = [
        <box
            $type="named"
            name="speaker"
            css="margin-bottom: 80px;"
            $={() => {
                speaker.connect('notify::mute', () => {
                    popup('speaker');
                });
            }}
        >
            <box class="osd-item widget">
                <icon icon={createBinding(speaker, 'volumeIcon')} />

                <ProgressBar
                    fraction={createBinding(speaker, 'volume')}
                    sensitive={createBinding(speaker, 'mute').as((v) => !v)}
                    valign={Gtk.Align.CENTER}
                />
            </box>
        </box>,

        <box
            $type="named"
            name="microphone"
            css="margin-bottom: 80px;"
            $={() => {
                microphone.connect('notify::mute', () => {
                    popup('microphone');
                });
            }}
        >
            <box class="osd-item widget">
                <icon icon={createBinding(microphone, 'volumeIcon')} />

                <ProgressBar
                    fraction={createBinding(microphone, 'volume')}
                    sensitive={createBinding(microphone, 'mute').as((v) => !v)}
                    valign={Gtk.Align.CENTER}
                />
            </box>
        </box>,

        <box
            $type="named"
            name="brightness"
            css="margin-bottom: 80px;"
            $={() => {
                brightness.connect('notify::screen-icon', () => {
                    popup('brightness');
                });
            }}
        >
            <box class="osd-item widget">
                <icon icon={createBinding(brightness, 'screenIcon')} />

                <ProgressBar
                    fraction={createBinding(brightness, 'screen')}
                    valign={Gtk.Align.CENTER}
                />
            </box>
        </box>,

        brightness.hasKbd && (
            <box
                $type="named"
                name="keyboard"
                css="margin-bottom: 80px;"
                $={() => {
                    brightness.connect('notify::kbd-level', () => {
                        popup('keyboard');
                    });
                }}
            >
                <box class="osd-item widget">
                    <icon icon="keyboard-brightness-symbolic" />

                    <ProgressBar
                        fraction={createBinding(brightness, 'kbdLevel').as(
                            (v) => (v ?? 0) / 2,
                        )}
                        sensitive={createBinding(brightness, 'kbdLevel').as(
                            (v) => v !== 0,
                        )}
                        valign={Gtk.Align.CENTER}
                    />
                </box>
            </box>
        ),

        <box
            $type="named"
            name="caps"
            css="margin-bottom: 80px;"
            $={() => {
                brightness.connect('notify::caps-icon', () => {
                    popup('caps');
                });
            }}
        >
            <box class="osd-item widget">
                <icon icon={createBinding(brightness, 'capsIcon')} />

                <label label="Caps Lock" />
            </box>
        </box>,
    ] as Gtk.Widget[];

    return (
        <PopupWindow
            name="osd"
            anchor={Astal.WindowAnchor.BOTTOM}
            exclusivity={Astal.Exclusivity.IGNORE}
            closeOnUnfocus="stay"
            transition="slide bottom"
        >
            <stack
                class="osd"
                transitionDuration={transition_duration}
                $={(self) => {
                    timeout(3 * 1000, () => {
                        stack = self;
                    });
                }}
            >
                {content}
            </stack>
        </PopupWindow>
    );
};

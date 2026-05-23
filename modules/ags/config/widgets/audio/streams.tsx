import { Astal, Gtk } from 'ags/gtk3';
import app from 'ags/gtk3/app';
import AstalApps from 'gi://AstalApps?version=0.1';
import AstalCava from 'gi://AstalCava';
import AstalWp from 'gi://AstalWp';
import { Accessor, createBinding, createEffect, For } from 'gnim';

import Separator from '../misc/separator';

const FPS = 60;

const getFullName = (stream: AstalWp.Stream): string => {
    let result = '';

    const desc = stream.description;
    const title = stream.name;

    if (desc) {
        result += desc;

        if (title) {
            result += ': ';
            result += title;
        }
    }
    else if (title) {
        result += title;
    }

    return result;
};

export default (
    streams: Accessor<AstalWp.Stream[]>,
    isVisible: Accessor<boolean>,
) => {
    const applications = AstalApps.Apps.new();

    return (
        <For
            each={streams.as((arr) =>
                arr
                    .filter((s) => s.description !== 'combined output')
                    .sort((a, b) =>
                        getFullName(a).localeCompare(getFullName(b)),
                    ),
            )}
        >
            {(stream: AstalWp.Stream) => {
                const icon = createBinding(stream, 'description').as((desc) => {
                    if (!desc) {
                        return 'audio-x-generic-symbolic';
                    }

                    return (
                        applications.fuzzy_query(desc).at(0)?.iconName ??
                        'audio-x-generic-symbolic'
                    );
                });

                const isWinVisible = createBinding(
                    app.get_window('win-audio')!,
                    'visible',
                );

                const cava = new AstalCava.Cava();
                cava.set_framerate(FPS);
                cava.set_bars(1);
                cava.set_input(AstalCava.Input.PIPEWIRE);
                cava.set_source(stream.serial.toString());

                createEffect(() => {
                    cava.set_active(isVisible() && isWinVisible());
                });

                const currentSoundValue = createBinding(cava, 'values').as(
                    (v) => v[0],
                );

                return (
                    <box class="stream" vertical>
                        <box class="title">
                            <icon icon={icon} />

                            <Separator size={8} />

                            <label
                                label={createBinding(stream, 'description').as(
                                    (v) => (v ? `${v}: ` : ''),
                                )}
                            />
                            <label
                                label={createBinding(stream, 'name').as(
                                    (v) => v ?? '',
                                )}
                            />
                        </box>

                        <Separator size={4} vertical />

                        <box class="body">
                            <cursor-button
                                cursor="pointer"
                                class="toggle"
                                valign={Gtk.Align.END}
                                onButtonReleaseEvent={() => {
                                    stream.set_mute(!stream.get_mute());
                                }}
                            >
                                <icon
                                    icon={createBinding(stream, 'mute').as(
                                        (isMuted) => {
                                            if (
                                                stream.get_media_class() ===
                                                AstalWp.MediaClass
                                                    .STREAM_INPUT_AUDIO
                                            ) {
                                                return isMuted
                                                    ? 'audio-input-microphone-muted-symbolic'
                                                    : 'audio-input-microphone-symbolic';
                                            }
                                            else {
                                                return isMuted
                                                    ? 'audio-volume-muted-symbolic'
                                                    : 'audio-speakers-symbolic';
                                            }
                                        },
                                    )}
                                />
                            </cursor-button>

                            <Separator size={4} />

                            <cursor-slider
                                hexpand
                                halign={Gtk.Align.FILL}
                                drawValue
                                cursor="pointer"
                                value={createBinding(stream, 'volume')}
                                onDragged={(self) => {
                                    stream.set_volume(self.value);
                                }}
                            />
                        </box>

                        <Separator vertical size={8} />

                        <levelbar
                            hexpand
                            halign={Gtk.Align.FILL}
                            value={currentSoundValue}
                        />

                        <Separator size={0} />
                    </box>
                ) as Astal.Box;
            }}
        </For>
    );
};

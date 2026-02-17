import { Astal, Gtk } from 'ags/gtk3';
import AstalWp from 'gi://AstalWp';
import { Accessor, createBinding, For } from 'gnim';

import Separator from '../misc/separator';
import { RadioButton } from '../misc/subclasses';

export default (streams: Accessor<AstalWp.Endpoint[]>) => {
    let group: RadioButton | undefined;

    return (
        <For
            each={streams.as((arr) =>
                arr.sort((a, b) => a.description.localeCompare(b.description)),
            )}
        >
            {(stream: AstalWp.Endpoint) => {
                return (
                    <box class="stream" vertical>
                        <box class="title">
                            <RadioButton
                                cursor="pointer"
                                css="margin-top: 1px;"
                                onRealize={(self) => {
                                    if (!group) {
                                        group = self;
                                    }
                                    else {
                                        self.group = group;
                                    }

                                    self.active = stream.get_is_default();
                                    stream.connect('notify::is-default', () => {
                                        self.active = stream.get_is_default();
                                    });
                                }}
                                onButtonReleaseEvent={() => {
                                    stream.set_is_default(true);
                                }}
                            />

                            <Separator size={8} />

                            <label
                                label={createBinding(stream, 'description')}
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
                    </box>
                ) as Astal.Box;
            }}
        </For>
    );
};

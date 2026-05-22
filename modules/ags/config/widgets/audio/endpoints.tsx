import { Astal, Gtk } from 'ags/gtk3';
import AstalWp from 'gi://AstalWp';
import { Accessor, createBinding, For } from 'gnim';

import Separator from '../misc/separator';
import { RadioButton } from '../misc/subclasses';

export default (endpoints: Accessor<AstalWp.Endpoint[]>) => {
    let group: RadioButton | undefined;

    return (
        <For
            each={endpoints.as((arr) =>
                arr.sort(
                    (a, b) =>
                        a.description?.localeCompare(b.description ?? '') ?? -1,
                ),
            )}
        >
            {(endpoint: AstalWp.Endpoint) => {
                return (
                    <box class="endpoint" vertical>
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

                                    self.active = endpoint.get_is_default();
                                    endpoint.connect(
                                        'notify::is-default',
                                        () => {
                                            self.active =
                                                endpoint.get_is_default();
                                        },
                                    );
                                }}
                                onButtonReleaseEvent={() => {
                                    endpoint.set_is_default(true);
                                }}
                            />

                            <Separator size={8} />

                            <label
                                label={createBinding(
                                    endpoint,
                                    'description',
                                ).as((v) => v ?? '')}
                            />
                        </box>

                        <Separator size={4} vertical />

                        <box class="body">
                            <cursor-button
                                cursor="pointer"
                                class="toggle"
                                valign={Gtk.Align.END}
                                onButtonReleaseEvent={() => {
                                    endpoint.set_mute(!endpoint.get_mute());
                                }}
                            >
                                <icon
                                    icon={createBinding(endpoint, 'mute').as(
                                        (isMuted) => {
                                            if (
                                                endpoint.get_media_class() ===
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
                                value={createBinding(endpoint, 'volume')}
                                onDragged={(self) => {
                                    endpoint.set_volume(self.value);
                                }}
                            />
                        </box>
                    </box>
                ) as Astal.Box;
            }}
        </For>
    );
};

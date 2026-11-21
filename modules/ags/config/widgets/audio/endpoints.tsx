import { Gtk } from 'ags/gtk4';
import AstalWp from 'gi://AstalWp';
import { Accessor, createBinding, For } from 'gnim';

import { pointer } from '../../lib/widgets';
import Separator from '../misc/separator';

export default (endpoints: Accessor<AstalWp.Endpoint[]>) => {
    let group: Gtk.CheckButton | undefined;

    return (
        <For
            each={endpoints.as((arr) =>
                arr.sort(
                    (a, b) =>
                        a.description?.localeCompare(b.description ?? '') ?? -1,
                ),
            )}
        >
            {(endpoint: AstalWp.Endpoint) =>
                (
                    <box
                        class="endpoint"
                        orientation={Gtk.Orientation.VERTICAL}
                    >
                        <box class="title">
                            <Gtk.CheckButton
                                cursor={pointer}
                                css="margin-top: 1px;"
                                active={createBinding(endpoint, 'isDefault')}
                                $={(self) => {
                                    if (!group) {
                                        group = self;
                                    }
                                    else {
                                        self.set_group(group);
                                    }
                                }}
                                onToggled={(self) => {
                                    if (
                                        self.active &&
                                        !endpoint.get_is_default()
                                    ) {
                                        endpoint.set_is_default(true);
                                    }
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
                            <button
                                cursor={pointer}
                                class="toggle"
                                valign={Gtk.Align.END}
                                onClicked={() => {
                                    endpoint.set_mute(!endpoint.get_mute());
                                }}
                            >
                                <image
                                    iconName={createBinding(
                                        endpoint,
                                        'mute',
                                    ).as((isMuted) => {
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
                                    })}
                                />
                            </button>

                            <Separator size={4} />

                            <slider
                                hexpand
                                halign={Gtk.Align.FILL}
                                drawValue
                                cursor={pointer}
                                value={createBinding(endpoint, 'volume')}
                                onChangeValue={(_, __, value) => {
                                    endpoint.set_volume(value);
                                }}
                            />
                        </box>
                    </box>
                ) as Gtk.Box
            }
        </For>
    );
};

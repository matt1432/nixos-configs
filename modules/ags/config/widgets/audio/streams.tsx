import { bind } from 'astal';
import { Gtk } from 'astal/gtk3';
import AstalWp from 'gi://AstalWp';

import Separator from '../misc/separator';
import { RadioButton } from '../misc/subclasses';

export default (streams: AstalWp.Endpoint[]) => {
    let group: RadioButton | undefined;

    return streams
        .sort((a, b) => a.get_description().localeCompare(b.get_description()))
        .map((stream) => (
            <box className="stream" vertical>
                <box className="title">
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
                            self.hook(stream, 'notify::is-default', () => {
                                self.active = stream.get_is_default();
                            });
                        }}
                        onButtonReleaseEvent={() => {
                            stream.set_is_default(true);
                        }}
                    />

                    <Separator size={8} />

                    <label label={bind(stream, 'description')} />
                </box>

                <Separator size={4} vertical />

                <box className="body">
                    <button
                        cursor="pointer"
                        className="toggle"
                        valign={Gtk.Align.END}
                        onButtonReleaseEvent={() => {
                            stream.set_mute(!stream.get_mute());
                        }}
                    >
                        <icon
                            icon={bind(stream, 'mute').as((isMuted) => {
                                if (
                                    stream.get_media_class() ===
                                    AstalWp.MediaClass.STREAM_INPUT_AUDIO
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
                        cursor="pointer"
                        value={bind(stream, 'volume')}
                        onDragged={(self) => {
                            stream.set_volume(self.value);
                        }}
                    />
                </box>
            </box>
        ));
};

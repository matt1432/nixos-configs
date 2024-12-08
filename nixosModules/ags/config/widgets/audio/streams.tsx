import { bind } from 'astal';
import { Gtk } from 'astal/gtk3';

import AstalWp from 'gi://AstalWp';

import { RadioButton } from '../misc/subclasses';
import Separator from '../misc/separator';


export default (streams: AstalWp.Endpoint[]) => {
    let group: RadioButton | undefined;

    return streams.map((stream) => (
        <box className="stream" vertical>

            <box className="title">

                <RadioButton
                    cursor="pointer"
                    css="margin-top: 1px;"

                    active={bind(stream, 'isDefault')}

                    onRealize={(self) => {
                        if (!group) {
                            group = self;
                        }
                        else {
                            self.group = group;
                        }
                    }}

                    onButtonReleaseEvent={() => {
                        stream.isDefault = true;
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
                        stream.mute = !stream.mute;
                    }}
                >
                    <icon
                        icon={bind(stream, 'mute').as((isMuted) => {
                            if (stream.mediaClass === AstalWp.MediaClass.AUDIO_MICROPHONE) {
                                return isMuted ?
                                    'audio-input-microphone-muted-symbolic' :
                                    'audio-input-microphone-symbolic';
                            }
                            else {
                                return isMuted ?
                                    'audio-volume-muted-symbolic' :
                                    'audio-speakers-symbolic';
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

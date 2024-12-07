import { bind } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';

import AstalWp from 'gi://AstalWp';

import { RadioButton } from '../misc/subclasses';
import Separator from '../misc/separator';


export default () => {
    const audio = AstalWp.get_default()?.get_audio();

    if (!audio) {
        throw new Error('Could not find default audio devices.');
    }

    // TODO: make a stack to have outputs, inputs and currently playing apps
    // TODO: figure out ports and profiles

    return (
        <box vertical className="widget audio">

            {bind(audio, 'speakers').as((speakers) => {
                const widgets = speakers.map((speaker, i) => (
                    <box className="stream" vertical>

                        <box className="title">

                            <RadioButton
                                css="margin-top: 1px;"

                                active={bind(speaker, 'isDefault')}

                                onRealize={(self) => {
                                    if (i !== 0) {
                                        self.group = (((widgets[0] as Widget.Box)
                                            .get_children()[0] as Widget.Box)
                                            .get_children()[0] as RadioButton);
                                    }
                                }}

                                onButtonReleaseEvent={() => {
                                    speaker.isDefault = true;
                                }}
                            />

                            <Separator size={8} />

                            <label label={bind(speaker, 'description')} />

                        </box>

                        <Separator size={4} vertical />

                        <box className="body">

                            <button
                                cursor="pointer"
                                className="toggle"
                                valign={Gtk.Align.END}

                                onButtonReleaseEvent={() => {
                                    speaker.mute = !speaker.mute;
                                }}
                            >
                                <icon
                                    icon={bind(speaker, 'mute').as((isMuted) => isMuted ?
                                        'audio-volume-muted-symbolic' :
                                        'audio-speakers-symbolic')}
                                />
                            </button>

                            <Separator size={4} />

                            {/*
                                FIXME: lockChannels not working
                                TODO: have two sliders when lockChannels === false
                            */}
                            <button
                                cursor="pointer"
                                className="toggle"
                                valign={Gtk.Align.END}

                                onButtonReleaseEvent={() => {
                                    speaker.lockChannels = !speaker.lockChannels;
                                }}
                            >
                                <icon
                                    icon={bind(speaker, 'lockChannels').as((locked) => locked ?
                                        'channel-secure-symbolic' :
                                        'channel-insecure-symbolic')}
                                />
                            </button>

                            <slider
                                hexpand
                                halign={Gtk.Align.FILL}
                                drawValue

                                value={bind(speaker, 'volume')}
                                onDragged={(self) => {
                                    speaker.set_volume(self.value);
                                }}
                            />

                        </box>

                    </box>
                ));

                return widgets;
            })}

        </box>
    );
};

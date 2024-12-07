import { bind } from 'astal';
import { Gtk, Widget } from 'astal/gtk3';

import AstalWp from 'gi://AstalWp';

import { RadioButton, ToggleButton } from '../misc/subclasses';
import Separator from '../misc/separator';


export default () => {
    const audio = AstalWp.get_default()?.get_audio();

    if (!audio) {
        throw new Error('Could not find default audio devices.');
    }

    // TODO: make a stack to have outputs, inputs and currently playing apps
    // TODO: figure out ports and profiles

    const defaultGroup = new RadioButton();

    return (
        <box vertical className="widget audio">
            {bind(audio, 'speakers').as((speakers) => speakers.map((speaker) => (
                <box className="stream" vertical>
                    <box className="title">
                        <RadioButton
                            css="margin-top: 1px;"

                            group={defaultGroup}
                            active={speaker.isDefault}

                            setup={(self) => {
                                speaker.connect('notify::isDefault', () => {
                                    self.active = speaker.isDefault;
                                });
                            }}

                            onToggled={(self) => {
                                speaker.isDefault = self.active;
                            }}
                        />

                        <Separator size={8} />

                        <label label={bind(speaker, 'description')} />
                    </box>

                    <Separator size={4} vertical />

                    <box className="body">
                        <ToggleButton
                            cursor="pointer"
                            valign={Gtk.Align.END}

                            active={speaker.mute}
                            onToggled={(self) => {
                                speaker.set_mute(self.active);

                                (self.get_child() as Widget.Icon).icon = self.active ?
                                    'audio-volume-muted-symbolic' :
                                    'audio-speakers-symbolic';
                            }}
                        >
                            <icon icon={speaker.mute ?
                                'audio-volume-muted-symbolic' :
                                'audio-speakers-symbolic'}
                            />
                        </ToggleButton>

                        <Separator size={4} />

                        {/*
                            FIXME: lockChannels not working
                            TODO: have two sliders when lockChannels === false
                        */}
                        <ToggleButton
                            cursor="pointer"
                            valign={Gtk.Align.END}

                            active={speaker.lockChannels}
                            onToggled={(self) => {
                                speaker.set_lock_channels(self.active);

                                (self.get_child() as Widget.Icon).icon = self.active ?
                                    'channel-secure-symbolic' :
                                    'channel-insecure-symbolic';
                            }}
                        >
                            <icon icon={speaker.lockChannels ?
                                'channel-secure-symbolic' :
                                'channel-insecure-symbolic'}
                            />
                        </ToggleButton>

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
            )))}
        </box>
    );
};

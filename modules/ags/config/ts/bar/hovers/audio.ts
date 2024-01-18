import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Label, Icon } from 'resource:///com/github/Aylur/ags/widget.js';

import { SpeakerIcon } from '../../misc/audio-icons.ts';
import HoverRevealer from './hover-revealer.ts';


export default () => HoverRevealer({
    class_name: 'audio',

    icon: Icon({
        icon: SpeakerIcon.bind(),
    }),

    label: Label().hook(Audio, (self) => {
        if (Audio.speaker?.volume) {
            self.label =
                `${Math.round(Audio.speaker?.volume * 100)}%`;
        }
    }, 'speaker-changed'),
});

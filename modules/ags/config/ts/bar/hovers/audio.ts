const Audio = await Service.import('audio');
const { Label, Icon } = Widget;

import { SpeakerIcon } from '../../misc/audio-icons.ts';
import HoverRevealer from './hover-revealer.ts';


export default () => HoverRevealer({
    class_name: 'audio',

    icon: Icon({
        icon: SpeakerIcon.bind(),
    }),

    label: Label().hook(Audio, (self) => {
        if (Audio.speaker.volume) {
            self.label =
                `${Math.round(Audio.speaker.volume * 100)}%`;
        }
    }, 'speaker-changed'),
});

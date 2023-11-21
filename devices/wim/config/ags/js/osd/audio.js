import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

import { SpeakerIcon } from '../misc/audio-icons.js';

const AUDIO_MAX = 1.5;


export default () => Box({
    className: 'osd',
    children: [
        Icon({
            hpack: 'start',
            binds: [['icon', SpeakerIcon, 'value']],
        }),

        ProgressBar({
            vpack: 'center',

            connections: [[Audio, (self) => {
                if (!Audio.speaker) {
                    return;
                }

                self.value = Audio.speaker ?
                    Audio.speaker.volume / AUDIO_MAX :
                    0;

                self.sensitive = !Audio.speaker?.stream.isMuted;

                const stack = self.get_parent().get_parent();

                stack.shown = 'audio';
                stack.resetTimer();
            }, 'speaker-changed']],
        }),
    ],
});

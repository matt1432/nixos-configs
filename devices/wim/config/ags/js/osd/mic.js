import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

import { MicIcon } from '../misc/audio-icons.js';


export default () => Box({
    className: 'osd',

    children: [
        Icon({
            hpack: 'start',
            binds: [['icon', MicIcon, 'value']],
        }),

        ProgressBar({
            vpack: 'center',

            connections: [[Audio, (self) => {
                if (!Audio.microphone) {
                    return;
                }

                self.value = Audio.microphone ? Audio.microphone.volume : 0;
                self.sensitive = !Audio.microphone?.stream.isMuted;

                const stack = self.get_parent().get_parent();

                stack.shown = 'mic';
                stack.resetTimer();
            }, 'microphone-changed']],
        }),
    ],
});

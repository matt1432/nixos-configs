import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

const items = {
    101: 'audio-volume-overamplified-symbolic',
    67: 'audio-volume-high-symbolic',
    34: 'audio-volume-medium-symbolic',
    1: 'audio-volume-low-symbolic',
    0: 'audio-volume-muted-symbolic',
};


export default () => Box({
    className: 'osd',
    children: [
        Icon({
            hpack: 'start',
            connections: [[Audio, self => {
                if (!Audio.speaker)
                    return;

                if (Audio.speaker.stream.isMuted) {
                    self.icon = items[0];
                }
                else {
                    const vol = Audio.speaker.volume * 100;

                    for (const threshold of [-1, 0, 33, 66, 100]) {
                        if (vol > threshold + 1)
                            self.icon = items[threshold + 1];
                    }
                }

                const stack = self.get_parent().get_parent();
                stack.shown = 'audio';
                stack.resetTimer();
            }, 'speaker-changed']],
        }),

        ProgressBar({
            vpack: 'center',
            connections: [[Audio, self => {
                self.value = Audio.speaker ? Audio.speaker.volume / 1.5 : 0;
                self.sensitive = !Audio.speaker?.stream.isMuted;
            }]],
        }),
    ],
});

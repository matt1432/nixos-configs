import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import { Box, Icon, ProgressBar } from 'resource:///com/github/Aylur/ags/widget.js';

const items = {
    67: 'audio-input-microphone-high-symbolic',
    34: 'audio-input-microphone-medium-symbolic',
    1: 'audio-input-microphone-low-symbolic',
    0: 'audio-input-microphone-muted-symbolic',
};


export default () => Box({
    className: 'osd',
    children: [
        Icon({
            hpack: 'start',
            connections: [[Audio, self => {
                if (!Audio.microphone)
                    return;

                if (Audio.microphone.stream.isMuted) {
                    self.icon = items[0];
                }
                else {
                    const vol = Audio.microphone.volume * 100;

                    for (const threshold of [-1, 0, 33, 66]) {
                        if (vol > threshold + 1)
                            self.icon = items[threshold + 1];
                    }
                }

                const stack = self.get_parent().get_parent();
                stack.shown = 'mic';
                stack.resetTimer();
            }, 'microphone-changed']],
        }),

        ProgressBar({
            vpack: 'center',
            connections: [[Audio, self => {
                self.value = Audio.microphone ? Audio.microphone.volume : 0;
                self.sensitive = !Audio.microphone?.stream.isMuted;
            }, 'microphone-changed']],
        }),
    ],
});

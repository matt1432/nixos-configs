import { Audio, Widget } from '../../imports.js';
const { Label, Box, Icon } = Widget;

import Separator from '../misc/separator.js';
import EventBox  from '../misc/cursorbox.js';

const items = {
    101: 'audio-volume-overamplified-symbolic',
    67: 'audio-volume-high-symbolic',
    34: 'audio-volume-medium-symbolic',
    1: 'audio-volume-low-symbolic',
    0: 'audio-volume-muted-symbolic',
};


const SpeakerIndicator = props => Icon({
    ...props,
    icon: '',
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
    }, 'speaker-changed']],
});

const SpeakerPercentLabel = props => Label({
    ...props,
    connections: [[Audio, label => {
        if (Audio.speaker)
            label.label = Math.round(Audio.speaker.volume * 100) + '%';
    }, 'speaker-changed']],
});

export default () => EventBox({
    onPrimaryClickRelease: 'pavucontrol',
    className: 'toggle-off',
    child: Box({
        className: 'audio',
        children: [
            SpeakerIndicator(),
            Separator(5),
            SpeakerPercentLabel(),
        ],
    }),
});
